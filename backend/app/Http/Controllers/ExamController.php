<?php

namespace App\Http\Controllers;

use App\Models\Exam;
use Illuminate\Http\Request;

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

        // Transform image paths to full URLs
        $exam->questions->transform(function ($question) {
            if ($question->image_path) {
                // Use 10.0.2.2 for Android emulator access to localhost
                $baseUrl = 'http://10.0.2.2:8080'; 
                $question->image_url = $baseUrl . $question->image_path;
            }
            return $question;
        });

        return $exam;
    }
}
