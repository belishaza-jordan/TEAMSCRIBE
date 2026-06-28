<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class Announcement extends Model
{
    protected $fillable = ['admin_id', 'title', 'message', 'target', 'target_university', 'is_sent', 'sent_at'];

    protected function casts(): array
    {
        return ['is_sent' => 'boolean', 'sent_at' => 'datetime'];
    }

    public function admin(): BelongsTo
    {
        return $this->belongsTo(User::class, 'admin_id');
    }
}
