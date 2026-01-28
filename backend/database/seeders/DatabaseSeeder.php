<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use App\Models\User;
use App\Models\Exam;
use App\Models\Question;
use Illuminate\Support\Facades\Hash;

class DatabaseSeeder extends Seeder
{
    public function run(): void
    {
        // 1. Create a user
        User::firstOrCreate(
            ['email' => 'student@theoriezone.nl'],
            [
                'name' => 'Student Demo',
                'password' => Hash::make('password'),
            ]
        );

        // 2. Create the Exam
        $exam = Exam::firstOrCreate(
            ['slug' => 'auto-theorie-b-oefenexamen-1'],
            [
                'title' => 'Auto Theorie B - Oefenexamen 1',
                'description' => 'Een realistische simulatie van het CBR examen. 50 vragen.',
                'duration_minutes' => 30,
                'passing_score' => 44,
                'total_questions' => 50,
            ]
        );

        // 3. Create the Question (Breath test)
        $q1 = Question::create([
            'text' => 'Als de agent je vraagt om mee te werken aan een ademtest, moet je daar dan aan meewerken?',
            'type' => 'multiple_choice',
            'options' => ['Ja', 'Nee'],
            'correct_index' => 0, // Ja
            'category' => 'Wetgeving',
            'image_path' => '/images/seed/breath_test.jpg', // Path relative to public
            'explanation' => 'Je bent verplicht mee te werken aan een ademtest als een bevoegd ambtenaar dit vordert.',
        ]);

        // Link question to exam
        $exam->questions()->attach($q1->id, ['position' => 1]);

        // 4. Run Scraped Questions
        $this->call(ScrapedQuestionsSeeder::class);
    }
}
