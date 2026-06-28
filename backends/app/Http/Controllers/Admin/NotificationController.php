<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\Activity;

class NotificationController extends Controller
{
    public function feed()
    {
        $items = Activity::with(['user', 'group'])->latest()->limit(25)->get()->map(fn ($a) => [
            'id' => $a->id,
            'type' => $a->type,
            'description' => $a->description,
            'user' => $a->user?->name,
            'group' => $a->group?->name,
            'time' => $a->created_at->diffForHumans(),
            'iso' => $a->created_at->toISOString(),
        ]);

        return response()->json(['notifications' => $items]);
    }
}
