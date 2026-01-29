<?php

namespace App\Http\Controllers;

use App\Models\User;
use App\Models\ExamAttempt;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Auth;

class SchoolController extends Controller
{
    public function dashboard()
    {
        // For MVP, if not logged in or not instructor, redirect or show empty
        // We will assume the user accessing this route is an instructor for now
        // In real app, add middleware check.
        
        $instructor = Auth::user();
        if (!$instructor) {
            return redirect('/login-web'); // Quick web login needed
        }

        $students = $instructor->students()->withCount(['attempts as passed_exams' => function($q) {
            $q->where('passed', true);
        }])->get();

        return view('school.dashboard', compact('students'));
    }

    public function createStudent()
    {
        return view('school.create_student');
    }

    public function storeStudent(Request $request)
    {
        $data = $request->validate([
            'name' => 'required|string',
            'email' => 'required|email|unique:users',
            'password' => 'required|min:6',
        ]);

        User::create([
            'name' => $data['name'],
            'email' => $data['email'],
            'password' => Hash::make($data['password']),
            'role' => 'student',
            'instructor_id' => Auth::id(),
        ]);

        return redirect()->route('school.dashboard')->with('success', 'Leerling toegevoegd!');
    }

    public function showStudent($id)
    {
        $student = User::where('instructor_id', Auth::id())->findOrFail($id);
        
        $attempts = ExamAttempt::where('user_id', $student->id)
            ->with('exam')
            ->orderBy('created_at', 'desc')
            ->get();
            
        // Also fetch upcoming lessons
        $lessons = \App\Models\Lesson::where('student_id', $student->id)
            ->orderBy('start_time', 'asc')
            ->get();

        return view('school.student_detail', compact('student', 'attempts', 'lessons'));
    }
}
