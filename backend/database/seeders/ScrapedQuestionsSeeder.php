<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use App\Models\Question;
use App\Models\Exam;
use Illuminate\Support\Facades\File;

class ScrapedQuestionsSeeder extends Seeder
{
    public function run()
    {
        $exam = Exam::where('slug', 'auto-theorie-b-oefenexamen-1')->first();
        if (!$exam) return;

        // Lees JSON
        $jsonPath = database_path('seeders/all_questions.json');
        if (!File::exists($jsonPath)) {
            $this->command->warn("JSON file not found: $jsonPath");
            return;
        }

        $questions = json_decode(File::get($jsonPath), true);
        $this->command->info("Seeding " . count($questions) . " scraped questions...");

        // Detach old questions to avoid duplicates in pivot
        // $exam->questions()->detach(); // Optional: keep manual ones

        foreach ($questions as $q) {
            // Check if question exists to avoid re-inserting on multiple runs
            $question = Question::firstOrCreate(
                ['text' => $q['text']], 
                [
                    'type' => 'multiple_choice',
                    'options' => ['Ja', 'Nee'], // Placeholder
                    'correct_index' => 0, // Placeholder
                    'category' => $q['category'],
                    'explanation' => 'Uitleg volgt nog.',
                    // We slaan de raw image URL even op, 
                    // maar we moeten later nog een script maken om die images te downloaden
                    'image_path' => $q['image_raw'] ? ('/images/remote/' . basename($q['image_raw'])) : null
                ]
            );

            // Voeg toe aan examen als nog niet gekoppeld
            if (!$exam->questions()->where('question_id', $question->id)->exists()) {
                $exam->questions()->attach($question->id);
            }
        }
    }
}
