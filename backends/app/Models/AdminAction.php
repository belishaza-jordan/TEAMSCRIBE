<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class AdminAction extends Model
{
    protected $fillable = ['admin_id', 'action', 'target_type', 'target_id', 'description', 'metadata'];

    protected function casts(): array
    {
        return ['metadata' => 'array'];
    }

    public function admin(): BelongsTo
    {
        return $this->belongsTo(User::class, 'admin_id');
    }
}
