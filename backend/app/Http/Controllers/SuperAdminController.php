<?php

namespace App\Http\Controllers;

use App\Models\User;
use App\Models\ExamAttempt;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Hash;

class SuperAdminController extends Controller
{
    public function dashboard()
    {
        // Stats
        $stats = [
            'total_students' => User::where('role', 'student')->count(),
            'total_schools' => User::where('role', 'instructor')->count(),
            'total_exams' => ExamAttempt::count(),
            'exams_today' => ExamAttempt::whereDate('created_at', now())->count(),
        ];

        // List Schools (Instructors)
        $schools = User::where('role', 'instructor')
            ->withCount('students') // Count their students
            ->orderBy('created_at', 'desc')
            ->get();

        return view('admin.dashboard', compact('stats', 'schools'));
    }

    public function createSchool()
    {
        return view('admin.create_school');
    }

    public function storeSchool(Request $request)
    {
        $data = $request->validate([
            'name' => 'required|string', // School Name or Contact Person
            'email' => 'required|email|unique:users',
            'password' => 'required|min:6',
        ]);

        User::create([
            'name' => $data['name'],
            'email' => $data['email'],
            'password' => Hash::make($data['password']),
            'role' => 'instructor', // Only Admin creates Instructors
        ]);

        return redirect()->route('admin.dashboard')->with('success', 'Rijschool succesvol aangemaakt!');
    }
}
