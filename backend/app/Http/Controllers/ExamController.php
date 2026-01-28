<?php

namespace App\Http\Controllers;

use App\Models\Exam;
use App\Models\ExamAttempt;
use App\Models\Question;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;

class ExamController extends Controller
{
    public function index()
    {
        return Exam::where('is_active', true)->get(['id', 'title', 'description', 'duration_minutes', 'total_questions']);
    }

    public function show($id)
    {
        $exam = Exam::with(['questions' => function ($query) {
            $query->select('questions.id', 'text', 'type', 'options', 'category', 'image_path');
        }])->findOrFail($id);

        $this->transformImages($exam->questions);
        return $exam;
    }

    public function startRandom(Request $request)
    {
        // 1. Pick 50 random active questions
        $questions = Question::where('is_active', true)
            ->inRandomOrder()
            ->limit(50)
            ->get(['id', 'text', 'type', 'options', 'category', 'image_path']);

        if ($questions->isEmpty()) {
            return response()->json(['error' => 'No questions available'], 400);
        }

        $this->transformImages($questions);

        // 2. Create an Attempt record
        $attempt = ExamAttempt::create([
            'user_id' => 1, // Mock user
            'exam_id' => 1, // Link to default exam template
            'started_at' => now(),
            'status' => 'in_progress',
            'answers' => []
        ]);

        return response()->json([
            'attempt_id' => $attempt->id,
            'questions' => $questions,
            'duration_minutes' => 30
        ]);
    }

    private function transformImages($questions)
    {
        $baseUrl = 'http://10.0.2.2:8080';
        foreach ($questions as $question) {
            if ($question->image_path) {
                if (str_starts_with($question->image_path, 'http')) {
                    $question->image_url = $question->image_path;
                } else {
                    $question->image_url = $baseUrl . $question->image_path;
                }
            }
        }
    }
}
