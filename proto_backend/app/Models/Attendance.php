<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Attendance extends Model
{
    protected $table = 'attendance';

    protected $fillable = [
        'event_id',
        'staff_id',
        'time_in',
        'status',
        'method'
    ];
}
