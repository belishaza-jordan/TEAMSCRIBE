<?php

namespace App\Http\Resources\Api\V1;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

class ActivityResource extends JsonResource
{
    /**
     * Transform the resource into an array.
     *
     * @return array<string, mixed>
     */
    public function toArray(Request $request): array
    {
        $user = $this->whenLoaded('user');
        $name = $user ? $user->name : 'Unknown';
        $initials = collect(explode(' ', $name))
            ->filter()->take(2)->map(fn ($w) => strtoupper($w[0]))->implode('');

        return [
            'id' => $this->id,
            'type' => $this->type,
            'description' => $this->description,
            'user_id' => $this->user_id,
            'user_name' => $name,
            'user_initials' => $initials,
            'group_name' => $this->whenLoaded('group', fn () => $this->group->name),
            'group_id' => $this->group_id,
            'metadata' => $this->metadata,
            'created_at' => $this->created_at?->toISOString(),
        ];
    }
}
