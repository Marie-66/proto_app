<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Event;
use Illuminate\Http\Request; // ✅ ADD THIS

class EventController extends Controller
{
    public function index()
    {
        return response()->json(Event::all());
    }

    public function update(Request $request, $id)
    {
        $event = Event::find($id);

        if (!$event) {
            return response()->json([
                'message' => 'Event not found'
            ], 404);
        }

        $event->update([
            'title' => $request->title,
            'venue' => $request->venue,
            'department' => $request->department,
            'office' => $request->office,
            'organizer' => $request->organizer,
            'description' => $request->description,
            'capacity' => $request->capacity,
        ]);

        return response()->json([
            'message' => 'Event updated successfully',
            'data' => $event
        ]);
    }

    public function store(Request $request)
    {
        $event = Event::create([
            'title' => $request->title,
            'venue' => $request->venue,
            'department' => $request->department,
            'office' => $request->office,
            'organizer' => $request->organizer,
            'description' => $request->description,
            'capacity' => $request->capacity,
            'date_time' => now(), // or pass from Flutter later
            'is_open' => 1
        ]);

        return response()->json([
            'message' => 'Event created successfully',
            'data' => $event
        ], 201);
    }

    public function destroy($id)
    {
        $event = Event::find($id);

        if (!$event) {
            return response()->json([
                'message' => 'Event not found'
            ], 404);
        }

        $event->delete();

        return response()->json([
            'message' => 'Event deleted successfully'
        ]);
    }



}
