<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Staff;

class StaffController extends Controller
{
    public function showByStaffId($staff_id)
    {
        $staff = Staff::where('staff_id', $staff_id)
            ->where('is_active', true)
            ->first();

        if (!$staff) {
            return response()->json([
                'message' => 'Staff not found'
            ], 404);
        }

        return response()->json($staff);
    }
}   