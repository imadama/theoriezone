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
        $category = $request->input('category');
        
        $query = Question::where('is_active', true);
        
        if ($category && $category !== 'all') {
            // Fuzzy match because categories might be dirty scraped data
            $query->where('category', 'like', "%{$category}%");
        }

        $questions = $query->inRandomOrder()
            ->limit(50)
            ->get(['id', 'text', 'type', 'options', 'category', 'image_path']);

        if ($questions->isEmpty()) {
            return response()->json(['error' => 'No questions available'], 400);
        }

        $this->transformImages($questions);

        // Determine title
        $title = 'Oefenexamen';
        if ($category && $category !== 'all') {
            $title .= ' (' . ucfirst($category) . ')';
        }

        $attempt = ExamAttempt::create([
            'user_id' => $request->user()->id, 
            'exam_id' => 1, // We keep 1 as generic ID for now, or null
            'started_at' => now(),
            'status' => 'in_progress',
            'answers' => []
        ]);

        return response()->json([
            'attempt_id' => $attempt->id,
            'title' => $title,
            'questions' => $questions,
            'duration_minutes' => 30
        ]);
    }

    public function submit(Request $request, $attemptId)
    {
        $attempt = ExamAttempt::where('user_id', 1)->findOrFail($attemptId);
        if ($attempt->status !== 'in_progress') {
            return response()->json(['error' => 'Exam already finished'], 400);
        }

        $answers = $request->input('answers', []); // { question_id: index }
        
        // Calculate Score
        $questionIds = array_keys($answers);
        $questions = Question::whereIn('id', $questionIds)->get();
        
        $score = 0;
        $total = count($answers) > 0 ? count($answers) : 1; 

        foreach ($questions as $q) {
            $given = $answers[$q->id] ?? null;
            if ($given !== null && (int)$given === $q->correct_index) {
                $score++;
            }
        }

        // Threshold: 80%
        $passed = ($score / $total >= 0.8);

        $attempt->update([
            'status' => 'completed',
            'finished_at' => now(),
            'score' => $score,
            'passed' => $passed,
            'answers' => $answers
        ]);

        // Generate mistakes report
        $mistakes = [];
        foreach ($questions as $q) {
            $given = $answers[$q->id] ?? null;
            if ($given === null || (int)$given !== $q->correct_index) {
                // Enrich image URL
                $imageUrl = null;
                if ($q->image_path) {
                    $baseUrl = 'http://10.0.2.2:8080';
                    if (str_starts_with($q->image_path, 'http')) {
                        $imageUrl = $q->image_path;
                    } else {
                        $imageUrl = $baseUrl . $q->image_path;
                    }
                }

                $mistakes[] = [
                    'question_id' => $q->id,
                    'text' => $q->text,
                    'your_answer_index' => $given,
                    'correct_index' => $q->correct_index,
                    'options' => $q->options,
                    'explanation' => $q->explanation,
                    'image_url' => $imageUrl,
                ];
            }
        }

        return response()->json([
            'score' => $score,
            'total' => $total,
            'passed' => $passed,
            'grade' => round(($score / $total) * 10, 1),
            'mistakes' => $mistakes
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
