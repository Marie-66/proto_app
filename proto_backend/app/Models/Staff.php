<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Staff extends Model
{
    protected $table = 'staff';

    protected $fillable = [
        'staff_id',
        'full_name',
        'department',
        'office',
        'face_image',
        'is_active',
    ];
}