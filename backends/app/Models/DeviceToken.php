<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class DeviceToken extends Model
{
    /** @var list<string> */
    protected $fillable = ['user_id', 'token', 'platform'];
}
