<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\ExamAttempt;

class ExamAttemptController extends Controller
{
    public function index(Request $request)
    {
        $attempts = ExamAttempt::where('user_id', $request->user()->id)
            ->with(['exam:id,title']) // Load exam title
            ->orderBy('created_at', 'desc')
            ->get(['id', 'exam_id', 'score', 'passed', 'created_at', 'status']);

        // Transform for easier frontend consumption
        $attempts->transform(function ($attempt) {
            return [
                'id' => $attempt->id,
                'exam_title' => $attempt->exam ? $attempt->exam->title : 'Onbekend Examen',
                'score' => $attempt->score,
                'passed' => $attempt->passed,
                'status' => $attempt->status,
                'date' => $attempt->created_at->format('d-m-Y H:i'), // Friendly date
                'is_completed' => $attempt->status === 'completed',
            ];
        });

        return response()->json($attempts);
    }
}
