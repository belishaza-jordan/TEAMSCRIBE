<?php

namespace Tests\Feature\Api\V1;

use App\Mail\GroupInvitationMail;
use App\Models\Group;
use App\Models\GroupInvitation;
use App\Models\User;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Support\Facades\Mail;
use Laravel\Sanctum\Sanctum;
use Tests\TestCase;

class InvitationTest extends TestCase
{
    use RefreshDatabase;

    private function makeGroup(User $owner): Group
    {
        $group = Group::create([
            'name' => 'Team Alpha',
            'course' => 'CS101',
            'created_by' => $owner->id,
            'join_code' => Group::generateJoinCode(),
        ]);
        $group->members()->attach($owner->id, ['role' => 'admin']);

        return $group;
    }

    public function test_member_can_send_an_invitation_and_email_is_dispatched(): void
    {
        Mail::fake();

        $owner = User::factory()->create();
        $group = $this->makeGroup($owner);
        Sanctum::actingAs($owner);

        $response = $this->postJson("/api/v1/groups/{$group->id}/invitations", [
            'email' => 'invitee@example.com',
        ]);

        $response->assertCreated();
        $this->assertDatabaseHas('group_invitations', [
            'group_id' => $group->id,
            'email' => 'invitee@example.com',
            'status' => 'pending',
        ]);

        $invitation = GroupInvitation::first();
        $this->assertSame(64, strlen($invitation->token));
        Mail::assertSent(GroupInvitationMail::class, fn ($mail) => $mail->hasTo('invitee@example.com'));
    }

    public function test_non_member_cannot_send_an_invitation(): void
    {
        $owner = User::factory()->create();
        $group = $this->makeGroup($owner);

        Sanctum::actingAs(User::factory()->create());

        $this->postJson("/api/v1/groups/{$group->id}/invitations", [
            'email' => 'invitee@example.com',
        ])->assertForbidden();
    }

    public function test_sending_again_expires_the_previous_pending_invitation(): void
    {
        Mail::fake();

        $owner = User::factory()->create();
        $group = $this->makeGroup($owner);
        Sanctum::actingAs($owner);

        $this->postJson("/api/v1/groups/{$group->id}/invitations", ['email' => 'invitee@example.com'])->assertCreated();
        $this->postJson("/api/v1/groups/{$group->id}/invitations", ['email' => 'invitee@example.com'])->assertCreated();

        $this->assertSame(1, GroupInvitation::where('status', 'pending')->count());
        $this->assertSame(1, GroupInvitation::where('status', 'expired')->count());
    }

    public function test_invitee_sees_pending_invitation_in_their_list(): void
    {
        $owner = User::factory()->create();
        $group = $this->makeGroup($owner);
        $invitee = User::factory()->create();

        GroupInvitation::create([
            'group_id' => $group->id,
            'invited_by' => $owner->id,
            'email' => $invitee->email,
            'token' => str_repeat('a', 64),
            'status' => 'pending',
            'expires_at' => now()->addHours(48),
        ]);

        Sanctum::actingAs($invitee);

        $this->getJson('/api/v1/invitations')
            ->assertOk()
            ->assertJsonPath('invitations.0.group_name', 'Team Alpha')
            ->assertJsonPath('invitations.0.inviter_name', $owner->name);
    }

    public function test_invitee_can_accept_and_becomes_a_member(): void
    {
        $owner = User::factory()->create();
        $group = $this->makeGroup($owner);
        $invitee = User::factory()->create();

        $invitation = GroupInvitation::create([
            'group_id' => $group->id,
            'invited_by' => $owner->id,
            'email' => $invitee->email,
            'token' => str_repeat('b', 64),
            'status' => 'pending',
            'expires_at' => now()->addHours(48),
        ]);

        Sanctum::actingAs($invitee);

        $this->postJson("/api/v1/invitations/{$invitation->id}/accept")->assertOk();

        $this->assertTrue($group->fresh()->isMember($invitee->id));
        $this->assertSame('accepted', $invitation->fresh()->status);
    }

    public function test_user_cannot_accept_an_invitation_for_a_different_email(): void
    {
        $owner = User::factory()->create();
        $group = $this->makeGroup($owner);

        $invitation = GroupInvitation::create([
            'group_id' => $group->id,
            'invited_by' => $owner->id,
            'email' => 'someone-else@example.com',
            'token' => str_repeat('c', 64),
            'status' => 'pending',
            'expires_at' => now()->addHours(48),
        ]);

        Sanctum::actingAs(User::factory()->create());

        $this->postJson("/api/v1/invitations/{$invitation->id}/accept")->assertForbidden();
    }

    public function test_invitee_can_decline(): void
    {
        $owner = User::factory()->create();
        $group = $this->makeGroup($owner);
        $invitee = User::factory()->create();

        $invitation = GroupInvitation::create([
            'group_id' => $group->id,
            'invited_by' => $owner->id,
            'email' => $invitee->email,
            'token' => str_repeat('d', 64),
            'status' => 'pending',
            'expires_at' => now()->addHours(48),
        ]);

        Sanctum::actingAs($invitee);

        $this->postJson("/api/v1/invitations/{$invitation->id}/decline")->assertOk();

        $this->assertSame('rejected', $invitation->fresh()->status);
        $this->assertFalse($group->fresh()->isMember($invitee->id));
    }

    public function test_expired_invitation_cannot_be_accepted(): void
    {
        $owner = User::factory()->create();
        $group = $this->makeGroup($owner);
        $invitee = User::factory()->create();

        $invitation = GroupInvitation::create([
            'group_id' => $group->id,
            'invited_by' => $owner->id,
            'email' => $invitee->email,
            'token' => str_repeat('e', 64),
            'status' => 'pending',
            'expires_at' => now()->subMinute(),
        ]);

        Sanctum::actingAs($invitee);

        $this->postJson("/api/v1/invitations/{$invitation->id}/accept")->assertStatus(422);
        $this->assertFalse($group->fresh()->isMember($invitee->id));
    }
}
