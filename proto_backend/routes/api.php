<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\Api\EventController;
use App\Http\Controllers\Api\AttendanceController;
use App\Http\Controllers\Api\StaffController;

Route::get('/test', function () {
    return response()->json([
        'message' => 'Laravel API working'
    ]);
});
Route::get('/events', [EventController::class, 'index']);
Route::post('/events', [EventController::class, 'store']);
Route::put('/events/{id}', [EventController::class, 'update']);
Route::delete('/events/{id}', [EventController::class, 'destroy']);
Route::post('/attendance', [AttendanceController::class, 'store']);
Route::get('/staff/{staff_id}', [StaffController::class, 'showByStaffId']);
