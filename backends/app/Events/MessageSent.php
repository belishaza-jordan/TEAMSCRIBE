<?php

namespace App\Events;

use App\Http\Resources\Api\V1\MessageResource;
use App\Models\Message;
use Illuminate\Broadcasting\InteractsWithSockets;
use Illuminate\Broadcasting\PrivateChannel;
use Illuminate\Contracts\Broadcasting\ShouldBroadcastNow;
use Illuminate\Foundation\Events\Dispatchable;
use Illuminate\Queue\SerializesModels;

class MessageSent implements ShouldBroadcastNow
{
    use Dispatchable, InteractsWithSockets, SerializesModels;

    public function __construct(public readonly Message $message) {}

    /** @return array<int, PrivateChannel> */
    public function broadcastOn(): array
    {
        return [new PrivateChannel("group.{$this->message->group_id}")];
    }

    /** @return array<string, mixed> */
    public function broadcastWith(): array
    {
        return (new MessageResource($this->message->load('sender')))->resolve();
    }

    public function broadcastAs(): string
    {
        return 'message.sent';
    }
}
