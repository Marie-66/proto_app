<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Event extends Model
{
    protected $fillable = [
        'title',
        'venue',
        'department',
        'office',
        'organizer',
        'description',
        'capacity',
        'date_time',
        'is_open'
    ];
}
