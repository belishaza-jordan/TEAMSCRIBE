<?php

namespace App\Http\Controllers\Api\V1;

use App\Http\Controllers\Controller;
use App\Mail\GroupInvitationMail;
use App\Models\Group;
use App\Models\GroupInvitation;
use App\Models\User;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Mail;
use Illuminate\Support\Str;

class InvitationController extends Controller
{
    /**
     * Send an email invitation to join a group.
     * Creates a pending invitation record and emails an accept/reject link.
     */
    public function store(Request $request, Group $group): JsonResponse
    {
        abort_unless($group->isMember($request->user()->id), 403);

        $request->validate([
            'email' => ['required', 'email'],
        ]);

        $email = strtolower(trim($request->email));

        // Don't re-invite someone who is already a member
        $existing = User::where('email', $email)->first();
        if ($existing && $group->isMember($existing->id)) {
            return response()->json(['message' => 'This person is already a member of the group.'], 422);
        }

        // Cancel any existing pending invitation for the same email+group
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

        $acceptUrl = route('invitations.accept', $invitation->token);
        $rejectUrl = route('invitations.reject', $invitation->token);

        Mail::to($email)->send(new GroupInvitationMail($invitation, $acceptUrl, $rejectUrl));

        return response()->json([
            'message' => "Invitation sent to {$email}. They'll receive an email to accept or decline.",
        ], 201);
    }
}
