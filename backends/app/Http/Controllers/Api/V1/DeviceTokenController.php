<?php

namespace App\Http\Controllers\Api\V1;

use App\Http\Controllers\Controller;
use App\Models\DeviceToken;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

class DeviceTokenController extends Controller
{
    /**
     * Register or refresh an FCM device token for the authenticated user.
     * If the token already exists for another user, it is reassigned.
     */
    public function register(Request $request): JsonResponse
    {
        $request->validate([
            'token' => ['required', 'string'],
            'platform' => ['sometimes', 'string', 'in:android,ios'],
        ]);

        DeviceToken::updateOrCreate(
            ['token' => $request->token],
            [
                'user_id' => $request->user()->id,
                'platform' => $request->input('platform', 'android'),
            ]
        );

        return response()->json(['message' => 'Device token registered.']);
    }

    /**
     * Remove the device token on logout so the user stops receiving notifications.
     */
    public function remove(Request $request): JsonResponse
    {
        $request->validate([
            'token' => ['required', 'string'],
        ]);

        DeviceToken::where('token', $request->token)
            ->where('user_id', $request->user()->id)
            ->delete();

        return response()->json(['message' => 'Device token removed.']);
    }
}
