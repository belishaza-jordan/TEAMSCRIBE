<?php

namespace App\Http\Controllers\Api\V1;

use App\Http\Controllers\Controller;
use App\Http\Resources\Api\V1\GroupResource;
use App\Mail\GroupInvitationMail;
use App\Models\Group;
use App\Models\GroupInvitation;
use App\Models\User;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Log;
use Illuminate\Support\Facades\Mail;
use Illuminate\Support\Str;

class InvitationController extends Controller
{
    /** List pending invitations for the authenticated user. */
    public function index(Request $request): JsonResponse
    {
        $invitations = GroupInvitation::where('email', $request->user()->email)
            ->where('status', 'pending')
            ->where('expires_at', '>', now())
            ->with(['group', 'inviter'])
            ->latest()
            ->get()
            ->map(fn ($inv) => [
                'id' => $inv->id,
                'group_id' => $inv->group_id,
                'group_name' => $inv->group->name,
                'group_course' => $inv->group->course,
                'inviter_name' => $inv->inviter->name,
                'expires_at' => $inv->expires_at->toISOString(),
            ]);

        return response()->json(['invitations' => $invitations]);
    }

    /** Accept a pending invitation — adds user to the group. */
    public function accept(Request $request, GroupInvitation $invitation): JsonResponse
    {
        abort_unless($invitation->email === $request->user()->email, 403);

        if (! $invitation->isPending()) {
            return response()->json(['message' => 'This invitation has expired or already been used.'], 422);
        }

        $group = $invitation->group;

        if (! $group->isMember($request->user()->id)) {
            $group->members()->attach($request->user()->id, ['role' => 'member']);
        }

        $invitation->update(['status' => 'accepted']);

        return response()->json([
            'message' => "You've joined {$group->name}!",
            'group' => new GroupResource($group->load(['members', 'sections.assignee'])),
        ]);
    }

    /** Decline a pending invitation. */
    public function decline(Request $request, GroupInvitation $invitation): JsonResponse
    {
        abort_unless($invitation->email === $request->user()->email, 403);

        if (! $invitation->isPending()) {
            return response()->json(['message' => 'This invitation has expired or already been used.'], 422);
        }

        $invitation->update(['status' => 'rejected']);

        return response()->json(['message' => 'Invitation declined.']);
    }

    /** Send an email invitation to join a group. */
    public function store(Request $request, Group $group): JsonResponse
    {
        abort_unless($group->isMember($request->user()->id), 403);

        $request->validate(['email' => ['required', 'email']]);

        $email = strtolower(trim($request->email));

        $existing = User::where('email', $email)->first();
        if ($existing && $group->isMember($existing->id)) {
            return response()->json(['message' => 'This person is already a member of the group.'], 422);
        }

        GroupInvitation::where('group_id', $group->id)
            ->where('email', $email)
            ->where('status', 'pending')
            ->update(['status' => 'expired']);

        $invitation = GroupInvitation::create([
            'group_id' => $group->id,
            'invited_by' => $request->user()->id,
            'email' => $email,
            'token' => Str::random(64),
            'status' => 'pending',
            'expires_at' => now()->addHours(48),
        ]);

        $invitation->load(['group.members', 'inviter']);

        try {
            Mail::to($email)->send(new GroupInvitationMail($invitation));
        } catch (\Throwable $e) {
            // Non-fatal — invitation record still created, but log so silent failures are traceable.
            Log::warning('Group invitation email failed to send', [
                'invitation_id' => $invitation->id,
                'email' => $email,
                'error' => $e->getMessage(),
            ]);
        }

        return response()->json([
            'message' => "Invitation sent to {$email}. They'll see it in their TeamScribe notifications.",
        ], 201);
    }
}
