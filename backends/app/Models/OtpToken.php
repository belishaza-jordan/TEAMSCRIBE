<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class OtpToken extends Model
{
    /** @var list<string> */
    protected $fillable = ['email', 'token', 'expires_at', 'used'];

    /** @return array<string, string> */
    protected function casts(): array
    {
        return [
            'expires_at' => 'datetime',
            'used' => 'boolean',
        ];
    }

    public function isValid(): bool
    {
        return ! $this->used && $this->expires_at->isFuture();
    }
}
