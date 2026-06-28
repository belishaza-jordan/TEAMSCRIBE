<?php

use App\Models\Group;
use Illuminate\Support\Facades\Broadcast;

Broadcast::channel('App.Models.User.{id}', function ($user, $id) {
    return (int) $user->id === (int) $id;
});

// Authorize a user to subscribe to a group's private channel
Broadcast::channel('group.{groupId}', function ($user, int $groupId) {
    return Group::find($groupId)?->isMember($user->id) ?? false;
});
