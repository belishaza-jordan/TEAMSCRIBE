<?php

namespace App\Http\Resources\Api\V1;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

class SectionResource extends JsonResource
{
    /**
     * Transform the resource into an array.
     *
     * @return array<string, mixed>
     */
    public function toArray(Request $request): array
    {
        $assignee = $this->whenLoaded('assignee');
        $assignName = $assignee ? $assignee->name : null;
        $initials = $assignName
            ? collect(explode(' ', $assignName))
                ->filter()->take(2)->map(fn ($w) => strtoupper($w[0]))->implode('')
            : null;

        return [
            'id' => $this->id,
            'group_id' => $this->group_id,
            'title' => $this->title,
            'assigned_to' => $this->assigned_to,
            'assigned_name' => $assignName,
            'assigned_initials' => $initials,
            'status' => $this->status,
            'progress' => $this->progress,
            'due_date' => $this->due_date?->toDateString(),
            'updated_at' => $this->updated_at?->toISOString(),
        ];
    }
}
