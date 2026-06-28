<?php

namespace App\Http\Controllers\Api\V1;

use App\Http\Controllers\Controller;
use App\Http\Resources\Api\V1\GroupResource;
use App\Models\Activity;
use App\Models\Group;
use App\Models\User;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

class GroupController extends Controller
{
    /** List all groups the authenticated user belongs to. */
    public function index(Request $request): JsonResponse
    {
        $groups = $request->user()
            ->groups()
            ->with(['members', 'sections'])
            ->latest()
            ->get();

        return response()->json(['groups' => GroupResource::collection($groups)]);
    }

    /** Create a new group and add creator as admin. */
    public function store(Request $request): JsonResponse
    {
        $validated = $request->validate([
            'name' => ['required', 'string', 'max:255'],
            'course' => ['nullable', 'string', 'max:100'],
            'description' => ['nullable', 'string', 'max:500'],
        ]);

        $group = Group::create([
            ...$validated,
            'created_by' => $request->user()->id,
            'join_code' => Group::generateJoinCode(),
        ]);

        $group->members()->attach($request->user()->id, ['role' => 'admin']);

        return response()->json(
            ['group' => new GroupResource($group->load(['members', 'sections']))],
            201
        );
    }

    /** Get a single group (member only). */
    public function show(Request $request, Group $group): JsonResponse
    {
        abort_unless($group->isMember($request->user()->id), 403);

        return response()->json([
            'group' => new GroupResource($group->load(['members', 'sections.assignee'])),
        ]);
    }

    /** Update a group (admin only). */
    public function update(Request $request, Group $group): JsonResponse
    {
        abort_unless($group->created_by === $request->user()->id, 403);

        $group->update($request->validate([
            'name' => ['sometimes', 'string', 'max:255'],
            'course' => ['nullable', 'string', 'max:100'],
            'description' => ['nullable', 'string', 'max:500'],
        ]));

        return response()->json(['group' => new GroupResource($group->fresh(['members', 'sections']))]);
    }

    /** Delete a group (creator only). */
    public function destroy(Request $request, Group $group): JsonResponse
    {
        abort_unless($group->created_by === $request->user()->id, 403);
        $group->delete();

        return response()->json(['message' => 'Group deleted.']);
    }

    /** Add a member by email. */
    public function addMember(Request $request, Group $group): JsonResponse
    {
        abort_unless($group->isMember($request->user()->id), 403);

        $request->validate(['email' => ['required', 'email', 'exists:users,email']]);

        $newMember = User::where('email', $request->email)->first();

        if ($group->isMember($newMember->id)) {
            return response()->json(['message' => 'User is already a member.'], 422);
        }

        $group->members()->attach($newMember->id, ['role' => 'member']);

        return response()->json(['message' => 'Member added.']);
    }

    /** Remove a member (admin only, cannot remove creator). */
    public function removeMember(Request $request, Group $group, int $userId): JsonResponse
    {
        abort_unless($group->created_by === $request->user()->id, 403);
        abort_if($userId === $group->created_by, 422, 'Cannot remove the group creator.');

        $group->members()->detach($userId);

        return response()->json(['message' => 'Member removed.']);
    }

    /**
     * Generate a brand-new invite code for a group (admin only).
     * Immediately invalidates the previous code.
     */
    public function regenerateCode(Request $request, Group $group): JsonResponse
    {
        abort_unless($group->created_by === $request->user()->id, 403);

        $group->update(['join_code' => Group::generateJoinCode()]);

        return response()->json([
            'message' => 'New invite code generated.',
            'join_code' => $group->fresh()->join_code,
        ]);
    }

    /**
     * Join a group using a 6-character invite code.
     * Works for anyone who has the code — even if they found it outside the app.
     */
    public function join(Request $request): JsonResponse
    {
        $request->validate([
            'code' => ['required', 'string', 'size:6'],
        ]);

        $group = Group::where('join_code', strtoupper($request->code))->first();

        if (! $group) {
            return response()->json(['message' => 'Invalid invite code.'], 404);
        }

        if ($group->isMember($request->user()->id)) {
            return response()->json([
                'message' => 'You are already a member of this group.',
                'group' => new GroupResource($group->load(['members', 'sections'])),
            ]);
        }

        $group->members()->attach($request->user()->id, ['role' => 'member']);

        Activity::create([
            'group_id' => $group->id,
            'user_id' => $request->user()->id,
            'type' => 'member_joined',
            'description' => "{$request->user()->name} joined the group",
            'metadata' => [],
        ]);

        return response()->json([
            'message' => 'You have joined the group successfully!',
            'group' => new GroupResource($group->fresh(['members', 'sections'])),
        ], 201);
    }
}
