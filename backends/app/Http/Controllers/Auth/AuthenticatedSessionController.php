<?php

namespace App\Http\Controllers\Auth;

use App\Http\Controllers\Controller;
use App\Http\Requests\Auth\LoginRequest;
use App\Models\Activity;
use Illuminate\Http\RedirectResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\View\View;

class AuthenticatedSessionController extends Controller
{
    /**
     * Display the login view.
     */
    public function create(): View
    {
        return view('auth.login');
    }

    /**
     * Handle an incoming authentication request.
     */
    public function store(LoginRequest $request): RedirectResponse
    {
        $request->authenticate();

        $request->session()->regenerate();

        // Log admin web login — wrapped in try/catch so a logging failure
        // never prevents the admin from signing in.
        try {
            Activity::create([
                'group_id' => null,
                'user_id' => auth()->id(),
                'type' => 'admin_login',
                'description' => auth()->user()->name.' signed in to admin panel',
                'metadata' => ['email' => auth()->user()->email, 'platform' => 'web'],
            ]);
        } catch (\Throwable) {
            // Non-fatal — log and continue
        }

        return redirect()->intended(route('admin.dashboard'));
    }

    /**
     * Destroy an authenticated session.
     */
    public function destroy(Request $request): RedirectResponse
    {
        // Log admin logout — wrapped in try/catch so a logging failure
        // NEVER blocks the user from signing out.
        try {
            if (auth()->check()) {
                Activity::create([
                    'group_id' => null,
                    'user_id' => auth()->id(),
                    'type' => 'admin_logout',
                    'description' => auth()->user()->name.' signed out of admin panel',
                    'metadata' => ['email' => auth()->user()->email, 'platform' => 'web'],
                ]);
            }
        } catch (\Throwable) {
            // Non-fatal
        }

        Auth::guard('web')->logout();

        $request->session()->invalidate();

        $request->session()->regenerateToken();

        return redirect('/');
    }
}
