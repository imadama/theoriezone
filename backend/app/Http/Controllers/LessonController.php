<?php

namespace App\Http\Controllers;

use App\Models\Lesson;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;

class LessonController extends Controller
{
    // API: Get lessons for student
    public function index(Request $request)
    {
        $lessons = Lesson::where('student_id', $request->user()->id)
            ->where('status', '!=', 'cancelled')
            ->orderBy('start_time', 'asc')
            ->with('instructor:id,name') // Load instructor name
            ->get();

        return response()->json($lessons);
    }

    // WEB: Store lesson (Instructor creates)
    public function store(Request $request)
    {
        $data = $request->validate([
            'student_id' => 'required|exists:users,id',
            'date' => 'required|date',
            'time' => 'required', // HH:MM
            'duration' => 'required|integer|min:30', // Minutes
            'notes' => 'nullable|string',
        ]);

        $start = \Carbon\Carbon::parse($data['date'] . ' ' . $data['time']);
        $end = (clone $start)->addMinutes($data['duration']);

        Lesson::create([
            'instructor_id' => Auth::id(),
            'student_id' => $data['student_id'],
            'start_time' => $start,
            'end_time' => $end,
            'notes' => $data['notes'],
        ]);

        return back()->with('success', 'Rijles ingepland!');
    }
    
    // WEB: Delete/Cancel
    public function destroy($id)
    {
        $lesson = Lesson::where('instructor_id', Auth::id())->findOrFail($id);
        $lesson->delete();
        
        return back()->with('success', 'Rijles verwijderd.');
    }
}
