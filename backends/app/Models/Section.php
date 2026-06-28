<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class Section extends Model
{
    /** @var list<string> */
    protected $fillable = [
        'group_id', 'title', 'assigned_to',
        'status', 'progress', 'due_date',
    ];

    /** @return array<string, string> */
    protected function casts(): array
    {
        return [
            'due_date' => 'date',
            'progress' => 'integer',
        ];
    }

    public function assignee(): BelongsTo
    {
        return $this->belongsTo(User::class, 'assigned_to');
    }

    public function group(): BelongsTo
    {
        return $this->belongsTo(Group::class);
    }
}
