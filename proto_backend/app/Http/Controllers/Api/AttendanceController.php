<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Models\Attendance;

class AttendanceController extends Controller
{
    public function store(Request $request)
    {
        $attendance = Attendance::create([
            'event_id' => $request->event_id,
            'staff_id' => $request->staff_id,
            'time_in' => now(),
            'status' => 'present',
            'method' => $request->method ?? 'manual',
        ]);

        return response()->json([
            'message' => 'Attendance saved',
            'data' => $attendance
        ], 201);
    }
}
