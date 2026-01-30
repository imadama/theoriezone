<?php

use Illuminate\Foundation\Inspiring;
use Illuminate\Support\Facades\Artisan;
use App\Models\Question;

Artisan::command('inspire', function () {
    $this->comment(Inspiring::quote());
})->purpose('Display an inspiring quote');

Artisan::command('fix:answers', function () {
    // 1. Ademtest
    Question::where('text', 'like', '%ademtest%')->update([
        'options' => ['Ja', 'Nee'],
        'correct_index' => 0,
        'explanation' => 'Je bent verplicht mee te werken aan een voorlopig onderzoek zoals een ademtest.'
    ]);

    // 2. Gele onderbroken streep
    Question::where('text', 'like', '%gele onderbroken streep%')->update([
        'options' => ['Ja', 'Nee'],
        'correct_index' => 1,
        'explanation' => 'Bij een gele onderbroken streep mag je niet parkeren, maar wel passagiers laten in- of uitstappen.'
    ]);

    // 3. Mistachterlicht
    Question::where('text', 'like', '%mistachterlicht%')->where('text', 'like', '%regen%')->update([
        'options' => ['Ja', 'Nee'],
        'correct_index' => 1,
        'explanation' => 'Het mistachterlicht mag alleen gebruikt worden bij mist of sneeuwval < 50m. Bij regen verblindt het.'
    ]);
    
    // 4. Erf
    Question::where('text', 'like', '%erf%')->where('text', 'like', '%hoe hard%')->update([
        'options' => ['15 km/u', '30 km/u', '50 km/u'],
        'correct_index' => 0,
        'explanation' => 'Binnen een erf mag je stapvoets rijden (max 15 km/u).'
    ]);
    
    // 5. Alcohol Beginner
    Question::where('text', 'like', '%alcohol%')->where('text', 'like', '%beginnend%')->update([
        'options' => ['0,2 promille', '0,5 promille', '0,8 promille'],
        'correct_index' => 0,
        'explanation' => 'Beginnende bestuurders: max 0,2 promille.'
    ]);

     // 6. Alcohol Ervaren
    Question::where('text', 'like', '%alcohol%')->where('text', 'like', '%ervaren%')->update([
        'options' => ['0,2 promille', '0,5 promille', '0,8 promille'],
        'correct_index' => 1,
        'explanation' => 'Ervaren bestuurders: max 0,5 promille.'
    ]);
    
    $this->info('Fixed common answers!');
});
