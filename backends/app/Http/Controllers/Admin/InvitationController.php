<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\Activity;
use App\Models\GroupInvitation;
use App\Models\User;

class InvitationController extends Controller
{
    /** User clicks "Accept" link in their email. */
    public function accept(string $token)
    {
        $invitation = GroupInvitation::with(['group.members', 'inviter'])
            ->where('token', $token)->firstOrFail();

        if (! $invitation->isPending()) {
            return view('invitations.result', [
                'status' => 'expired',
                'message' => 'This invitation has already been used or has expired.',
                'group' => $invitation->group,
            ]);
        }

        $user = User::where('email', $invitation->email)->first();

        if (! $user) {
            return view('invitations.result', [
                'status' => 'no_account',
                'message' => 'No TeamScribe account found for this email. Please download the app and register first, then ask to be invited again.',
                'group' => $invitation->group,
            ]);
        }

        if ($invitation->group->isMember($user->id)) {
            $invitation->update(['status' => 'accepted']);

            return view('invitations.result', [
                'status' => 'already_member',
                'message' => "You are already a member of \"{$invitation->group->name}\".",
                'group' => $invitation->group,
            ]);
        }

        $invitation->group->members()->attach($user->id, ['role' => 'member']);
        $invitation->update(['status' => 'accepted']);

        Activity::create([
            'group_id' => $invitation->group_id,
            'user_id' => $user->id,
            'type' => 'member_joined',
            'description' => "{$user->name} accepted an email invitation to join \"{$invitation->group->name}\"",
            'metadata' => ['invited_by' => $invitation->inviter->name],
        ]);

        return view('invitations.result', [
            'status' => 'accepted',
            'message' => "Welcome! You've joined \"{$invitation->group->name}\". Open the TeamScribe app to start collaborating.",
            'group' => $invitation->group,
        ]);
    }

    /** User clicks "Decline" link in their email. */
    public function reject(string $token)
    {
        $invitation = GroupInvitation::with(['group', 'inviter'])
            ->where('token', $token)->firstOrFail();

        if ($invitation->isPending()) {
            $invitation->update(['status' => 'rejected']);
        }

        return view('invitations.result', [
            'status' => 'rejected',
            'message' => "You've declined the invitation to \"{$invitation->group->name}\". No further action is needed.",
            'group' => $invitation->group,
        ]);
    }
}
