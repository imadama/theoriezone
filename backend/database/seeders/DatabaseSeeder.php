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
        // 1. Create Instructor
        $instructor = User::firstOrCreate(
            ['email' => 'rijschool@test.nl'],
            [
                'name' => 'Instructeur Jan',
                'password' => Hash::make('rijschool123'),
                'role' => 'instructor',
            ]
        );

        // 2. Create Student linked to Instructor
        User::firstOrCreate(
            ['email' => 'leerling@test.nl'],
            [
                'name' => 'Leerling Piet',
                'password' => Hash::make('leerling123'),
                'role' => 'student',
                'instructor_id' => $instructor->id,
            ]
        );

        // 3. Create the Exam
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

        // 4. Run Scraped Questions
        $this->call(ScrapedQuestionsSeeder::class);
    }
}
