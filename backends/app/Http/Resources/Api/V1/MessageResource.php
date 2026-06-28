<?php

namespace App\Http\Resources\Api\V1;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

class MessageResource extends JsonResource
{
    /**
     * Transform the resource into an array.
     *
     * @return array<string, mixed>
     */
    public function toArray(Request $request): array
    {
        $sender = $this->whenLoaded('sender');
        $name = $sender ? $sender->name : 'Unknown';
        $initials = collect(explode(' ', $name))
            ->filter()->take(2)->map(fn ($w) => strtoupper($w[0]))->implode('');

        return [
            'id' => $this->id,
            'group_id' => $this->group_id,
            'user_id' => $this->user_id,
            'sender_name' => $name,
            'sender_initials' => $initials,
            'content' => $this->content,
            'created_at' => $this->created_at?->toISOString(),
        ];
    }
}
