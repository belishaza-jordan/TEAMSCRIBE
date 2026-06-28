<?php

use App\Http\Controllers\Api\V1\Auth\AuthController;
use App\Http\Controllers\Api\V1\DeviceTokenController;
use App\Http\Controllers\Api\V1\GroupController;
use App\Http\Controllers\Api\V1\InvitationController;
use App\Http\Controllers\Api\V1\MessageController;
use App\Http\Controllers\Api\V1\ProfileController;
use App\Http\Controllers\Api\V1\ProgressController;
use App\Http\Controllers\Api\V1\SectionController;
use Illuminate\Support\Facades\Route;

/*
|--------------------------------------------------------------------------
| API Routes — v1
|--------------------------------------------------------------------------
*/

Route::prefix('v1')->group(function () {

    // ── Public auth routes ────────────────────────────────────────────────
    Route::prefix('auth')->group(function () {
        Route::post('register', [AuthController::class, 'register']);
        Route::post('login', [AuthController::class, 'login']);
        Route::post('forgot-password', [AuthController::class, 'forgotPassword']);
        Route::post('verify-otp', [AuthController::class, 'verifyOtp']);
        Route::post('reset-password', [AuthController::class, 'resetPassword']);
    });

    // ── Authenticated routes ──────────────────────────────────────────────
    Route::middleware('auth:sanctum')->group(function () {
        Route::prefix('auth')->group(function () {
            Route::get('me', [AuthController::class, 'me']);
            Route::post('logout', [AuthController::class, 'logout']);
            Route::post('email/verify', [AuthController::class, 'verifyEmail']);
            Route::post('email/resend', [AuthController::class, 'resendVerification']);
        });

        // Profile
        Route::patch('profile', [ProfileController::class, 'update']);
        Route::post('profile/avatar', [ProfileController::class, 'uploadAvatar']);

        // FCM device tokens
        Route::post('device-tokens', [DeviceTokenController::class, 'register']);
        Route::delete('device-tokens', [DeviceTokenController::class, 'remove']);

        // Groups
        Route::post('groups/join', [GroupController::class, 'join']); // must be before {group}
        Route::get('groups', [GroupController::class, 'index']);
        Route::post('groups', [GroupController::class, 'store']);
        Route::get('groups/{group}', [GroupController::class, 'show']);
        Route::patch('groups/{group}', [GroupController::class, 'update']);
        Route::delete('groups/{group}', [GroupController::class, 'destroy']);
        Route::post('groups/{group}/members', [GroupController::class, 'addMember']);
        Route::delete('groups/{group}/members/{userId}', [GroupController::class, 'removeMember']);
        Route::post('groups/{group}/regenerate-code', [GroupController::class, 'regenerateCode']);

        // Email invitations (send invite → email with accept/reject link)
        Route::post('groups/{group}/invitations', [InvitationController::class, 'store']);

        // Messages (real-time via Reverb)
        Route::get('groups/{group}/messages', [MessageController::class, 'index']);
        Route::post('groups/{group}/messages', [MessageController::class, 'store']);

        // Notifications (cross-group activity feed)
        Route::get('notifications', [ProgressController::class, 'notifications']);

        // Progress tracking
        Route::get('groups/{group}/progress', [ProgressController::class, 'memberProgress']);
        Route::get('groups/{group}/activities', [ProgressController::class, 'activities']);

        // Sections / Tasks
        Route::get('groups/{group}/sections', [SectionController::class, 'index']);
        Route::post('groups/{group}/sections', [SectionController::class, 'store']);
        Route::patch('groups/{group}/sections/{section}', [SectionController::class, 'update']);
        Route::delete('groups/{group}/sections/{section}', [SectionController::class, 'destroy']);
    });

});
