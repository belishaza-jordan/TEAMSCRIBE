<?php

namespace App\Http\Resources\Api\V1;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

class GroupResource extends JsonResource
{
    /**
     * Transform the resource into an array.
     *
     * @return array<string, mixed>
     */
    public function toArray(Request $request): array
    {
        $sections = $this->whenLoaded('sections');
        $total = $sections ? $sections->count() : 0;
        $done = $sections ? $sections->where('status', 'done')->count() : 0;
        $progress = $total > 0 ? round($done / $total * 100) : 0;

        return [
            'id' => $this->id,
            'name' => $this->name,
            'course' => $this->course,
            'description' => $this->description,
            'created_by' => $this->created_by,
            'join_code' => $this->join_code,
            'member_count' => $this->whenLoaded('members', fn () => $this->members->count(), 0),
            'members' => UserResource::collection($this->whenLoaded('members')),
            'sections_total' => $total,
            'sections_done' => $done,
            'progress' => $progress,
            'created_at' => $this->created_at?->toISOString(),
        ];
    }
}
