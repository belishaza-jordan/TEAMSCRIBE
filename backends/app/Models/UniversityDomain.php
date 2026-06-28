<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class UniversityDomain extends Model
{
    protected $fillable = ['domain', 'university_name', 'is_allowed', 'approved_by'];
}
