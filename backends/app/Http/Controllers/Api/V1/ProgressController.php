<?php

namespace App\Http\Controllers\Api\V1;

use App\Http\Controllers\Controller;
use App\Http\Resources\Api\V1\ActivityResource;
use App\Models\Activity;
use App\Models\Group;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Storage;

class ProgressController extends Controller
{
    /**
     * Per-member progress breakdown for a group.
     * Returns each member with their sections and computed stats.
     */
    public function memberProgress(Request $request, Group $group): JsonResponse
    {
        abort_unless($group->isMember($request->user()->id), 403);

        $group->load(['members', 'sections.assignee']);

        $members = $group->members->map(function ($member) use ($group) {
            $assigned = $group->sections->where('assigned_to', $member->id);
            $done = $assigned->where('status', 'done')->count();
            $total = $assigned->count();
            $avgProgress = $total > 0
                ? (int) round($assigned->avg('progress'))
                : 0;

            $lastActivity = Activity::where('group_id', $group->id)
                ->where('user_id', $member->id)
                ->latest()
                ->value('created_at');

            return [
                'user_id' => $member->id,
                'name' => $member->name,
                'initials' => collect(explode(' ', $member->name))
                    ->filter()->take(2)->map(fn ($w) => strtoupper($w[0]))->implode(''),
                'avatar_url' => $member->avatar_path
                    ? Storage::disk('public')->url($member->avatar_path)
                    : null,
                'role' => $member->pivot->role,
                'sections_total' => $total,
                'sections_done' => $done,
                'avg_progress' => $avgProgress,
                'completion_rate' => $total > 0 ? round($done / $total * 100) : 0,
                'last_active_at' => $lastActivity?->toISOString(),
            ];
        });

        return response()->json(['members' => $members]);
    }

    /**
     * Recent activity feed for a group (last 30 events).
     */
    public function activities(Request $request, Group $group): JsonResponse
    {
        abort_unless($group->isMember($request->user()->id), 403);

        $activities = Activity::where('group_id', $group->id)
            ->with('user')
            ->latest()
            ->limit(30)
            ->get();

        return response()->json([
            'activities' => ActivityResource::collection($activities),
        ]);
    }

    /**
     * Global notifications — activities across ALL groups the user belongs to,
     * sorted newest first (last 40 events).
     */
    public function notifications(Request $request): JsonResponse
    {
        $groupIds = $request->user()->groups()->pluck('groups.id');

        $activities = Activity::whereIn('group_id', $groupIds)
            ->with(['user', 'group'])
            ->latest()
            ->limit(40)
            ->get();

        return response()->json([
            'notifications' => ActivityResource::collection($activities),
        ]);
    }
}
