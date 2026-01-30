<?php

namespace App\Http\Controllers;

use App\Models\Skill;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;

class ProgressController extends Controller
{
    // API: Get progress for student app
    public function index(Request $request)
    {
        $userId = $request->user()->id;
        
        $skills = Skill::all()->groupBy('category');
        $progress = DB::table('student_progress')
            ->where('student_id', $userId)
            ->pluck('score', 'skill_id');

        // Format for App
        $data = [];
        foreach ($skills as $cat => $catSkills) {
            $catData = [
                'category' => $cat,
                'skills' => []
            ];
            foreach ($catSkills as $skill) {
                $catData['skills'][] = [
                    'id' => $skill->id,
                    'name' => $skill->name,
                    'score' => $progress[$skill->id] ?? 0, // 0-5
                ];
            }
            $data[] = $catData;
        }

        return response()->json($data);
    }

    // WEB: Update progress (Instructor)
    public function update(Request $request)
    {
        $data = $request->validate([
            'student_id' => 'required|exists:users,id',
            'progress' => 'required|array', // [skill_id => score]
        ]);

        foreach ($data['progress'] as $skillId => $score) {
            DB::table('student_progress')->updateOrInsert(
                ['student_id' => $data['student_id'], 'skill_id' => $skillId],
                ['score' => $score, 'updated_at' => now()]
            );
        }

        return back()->with('success', 'Vorderingen bijgewerkt!');
    }
}
