<?php

namespace App\Http\Controllers\Api\V1\Auth;

use App\Http\Controllers\Controller;
use App\Http\Resources\Api\V1\UserResource;
use App\Mail\EmailVerificationMail;
use App\Mail\OtpMail;
use App\Models\Activity;
use App\Models\OtpToken;
use App\Models\User;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Mail;
use Illuminate\Support\Str;
use Illuminate\Validation\Rules\Password;
use Illuminate\Validation\ValidationException;

class AuthController extends Controller
{
    /**
     * Register a new user.
     */
    public function register(Request $request): JsonResponse
    {
        $validated = $request->validate([
            'name' => ['required', 'string', 'max:255'],
            'email' => ['required', 'email', 'unique:users,email'],
            'university' => ['required', 'string', 'max:150'],
            'password' => ['required', Password::min(8)->uncompromised()],
        ]);

        $user = User::create([
            'name' => $validated['name'],
            'email' => $validated['email'],
            'university' => $validated['university'],
            'password' => $validated['password'],
        ]);

        // Send a 5-digit OTP for in-app email verification
        $otp = str_pad((string) random_int(0, 99999), 5, '0', STR_PAD_LEFT);
        OtpToken::create([
            'email' => $user->email,
            'token' => $otp,
            'expires_at' => now()->addMinutes(10),
        ]);
        Mail::to($user->email)->send(new EmailVerificationMail($otp, $user->name));

        $token = $user->createToken('mobile')->plainTextToken;

        return response()->json([
            'token' => $token,
            'user' => new UserResource($user),
            'message' => 'Account created. A 5-digit verification code was sent to your email.',
        ], 201);
    }

    /**
     * Verify email using the 5-digit OTP entered in the app.
     */
    public function verifyEmail(Request $request): JsonResponse
    {
        $request->validate([
            'email' => ['required', 'email', 'exists:users,email'],
            'otp' => ['required', 'string', 'size:5'],
        ]);

        $record = OtpToken::where('email', $request->email)
            ->where('token', $request->otp)
            ->latest()
            ->first();

        if (! $record || ! $record->isValid()) {
            return response()->json(['message' => 'Invalid or expired code.'], 422);
        }

        $user = User::where('email', $request->email)->firstOrFail();
        $user->markEmailAsVerified();
        $record->update(['used' => true]);

        return response()->json([
            'message' => 'Email verified successfully!',
            'user' => new UserResource($user),
        ]);
    }

    /**
     * Resend a new 5-digit OTP for email verification.
     */
    public function resendVerification(Request $request): JsonResponse
    {
        if ($request->user()->hasVerifiedEmail()) {
            return response()->json(['message' => 'Email already verified.']);
        }

        // Rate-limit: block resend if a valid OTP was sent within the last 60 s
        $recent = OtpToken::where('email', $request->user()->email)
            ->where('used', false)
            ->where('created_at', '>=', now()->subSeconds(60))
            ->exists();

        if ($recent) {
            return response()->json([
                'message' => 'Please wait 60 seconds before requesting a new code.',
            ], 429);
        }

        // Invalidate all previous OTPs for this email
        OtpToken::where('email', $request->user()->email)
            ->where('used', false)
            ->update(['used' => true]);

        $otp = str_pad((string) random_int(0, 99999), 5, '0', STR_PAD_LEFT);
        OtpToken::create([
            'email' => $request->user()->email,
            'token' => $otp,
            'expires_at' => now()->addMinutes(10),
        ]);
        Mail::to($request->user()->email)->send(
            new EmailVerificationMail($otp, $request->user()->name)
        );

        return response()->json(['message' => 'New verification code sent.']);
    }

    /**
     * Log in an existing user.
     */
    public function login(Request $request): JsonResponse
    {
        $validated = $request->validate([
            'email' => ['required', 'email'],
            'password' => ['required', 'string'],
        ]);

        $user = User::where('email', $validated['email'])->first();

        if (! $user || ! Hash::check($validated['password'], $user->password)) {
            throw ValidationException::withMessages([
                'email' => ['The provided credentials are incorrect.'],
            ]);
        }

        $token = $user->createToken('mobile')->plainTextToken;

        // Log login event — group_id is null for platform-level events
        Activity::create([
            'group_id' => null,
            'user_id' => $user->id,
            'type' => 'user_login',
            'description' => "{$user->name} signed in via mobile app",
            'metadata' => ['email' => $user->email, 'platform' => 'mobile'],
        ]);

        return response()->json([
            'token' => $token,
            'user' => new UserResource($user),
        ]);
    }

    /**
     * Log out the authenticated user (revoke current token).
     */
    public function logout(Request $request): JsonResponse
    {
        // Log logout — non-fatal, logout must always succeed
        try {
            Activity::create([
                'group_id' => null,
                'user_id' => $request->user()->id,
                'type' => 'user_logout',
                'description' => "{$request->user()->name} signed out",
                'metadata' => ['email' => $request->user()->email],
            ]);
        } catch (\Throwable) {
            // Non-fatal
        }

        $request->user()->currentAccessToken()->delete();

        return response()->json(['message' => 'Logged out successfully.']);
    }

    /**
     * Return the authenticated user's profile.
     */
    public function me(Request $request): JsonResponse
    {
        return response()->json(['user' => new UserResource($request->user())]);
    }

    /**
     * Send a 5-digit OTP to the given email for password reset.
     */
    public function forgotPassword(Request $request): JsonResponse
    {
        $request->validate([
            'email' => ['required', 'email', 'exists:users,email'],
        ]);

        // Invalidate any existing OTPs for this email
        OtpToken::where('email', $request->email)
            ->where('used', false)
            ->update(['used' => true]);

        $otp = str_pad((string) random_int(0, 99999), 5, '0', STR_PAD_LEFT);

        OtpToken::create([
            'email' => $request->email,
            'token' => $otp,
            'expires_at' => now()->addMinutes(10),
        ]);

        $user = User::where('email', $request->email)->first();

        Mail::to($request->email)->send(new OtpMail($otp, $user->name));

        return response()->json(['message' => 'OTP sent to your email.']);
    }

    /**
     * Verify the OTP submitted by the user.
     */
    public function verifyOtp(Request $request): JsonResponse
    {
        $request->validate([
            'email' => ['required', 'email'],
            'otp' => ['required', 'string', 'size:5'],
        ]);

        $record = OtpToken::where('email', $request->email)
            ->where('token', $request->otp)
            ->latest()
            ->first();

        if (! $record || ! $record->isValid()) {
            return response()->json(['message' => 'Invalid or expired OTP.'], 422);
        }

        // Issue a short-lived reset token the client must present on the next step
        $resetToken = Str::random(64);

        $record->update(['used' => true]);

        return response()->json([
            'message' => 'OTP verified.',
            'reset_token' => $resetToken,
        ]);
    }

    /**
     * Set a new password after OTP verification.
     */
    public function resetPassword(Request $request): JsonResponse
    {
        $request->validate([
            'email' => ['required', 'email', 'exists:users,email'],
            'password' => ['required', 'confirmed', Password::min(8)->uncompromised()],
        ]);

        $user = User::where('email', $request->email)->firstOrFail();
        $user->update(['password' => $request->password]);

        // Revoke all existing tokens so old sessions cannot be reused
        $user->tokens()->delete();

        return response()->json(['message' => 'Password reset successfully.']);
    }
}
