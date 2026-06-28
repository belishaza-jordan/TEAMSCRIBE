<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\BelongsToMany;
use Illuminate\Database\Eloquent\Relations\HasMany;

class Group extends Model
{
    /** @var list<string> */
    /** @var list<string> */
    protected $fillable = ['name', 'course', 'description', 'created_by', 'join_code'];

    /**
     * Generate a unique 6-character code guaranteed to contain
     * at least 2 letters AND at least 2 numbers (e.g. "A3BX9K").
     * Ambiguous characters (O, 0, I, 1) are excluded.
     */
    public static function generateJoinCode(): string
    {
        $letters = 'ABCDEFGHJKLMNPQRSTUVWXYZ';
        $numbers = '23456789';
        $mixed = $letters.$numbers;

        do {
            // Lock in 2 letters + 2 numbers, fill remaining 2 from the full pool
            $parts = [
                $letters[random_int(0, strlen($letters) - 1)],
                $letters[random_int(0, strlen($letters) - 1)],
                $numbers[random_int(0, strlen($numbers) - 1)],
                $numbers[random_int(0, strlen($numbers) - 1)],
                $mixed[random_int(0, strlen($mixed) - 1)],
                $mixed[random_int(0, strlen($mixed) - 1)],
            ];
            // Shuffle so the letters/numbers aren't always in the same positions
            shuffle($parts);
            $code = implode('', $parts);
        } while (self::where('join_code', $code)->exists());

        return $code;
    }

    public function creator(): BelongsTo
    {
        return $this->belongsTo(User::class, 'created_by');
    }

    public function members(): BelongsToMany
    {
        return $this->belongsToMany(User::class, 'group_members')
            ->withPivot('role')
            ->withTimestamps();
    }

    public function messages(): HasMany
    {
        return $this->hasMany(Message::class);
    }

    public function sections(): HasMany
    {
        return $this->hasMany(Section::class);
    }

    public function isMember(int $userId): bool
    {
        return $this->members()->where('user_id', $userId)->exists();
    }
}
