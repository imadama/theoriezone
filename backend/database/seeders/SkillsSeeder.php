<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use App\Models\Skill;

class SkillsSeeder extends Seeder
{
    public function run(): void
    {
        $skills = [
            'Voertuigbeheersing' => [
                'Zithouding en spiegels',
                'Starten en wegrijden',
                'Sturen en kijkgedrag',
                'Schakelen en ontkoppelen',
                'Remmen en stoppen',
            ],
            'Beheersing verkeerssituaties' => [
                'Kruispunten (oversteken/afslaan)',
                'Rechtsaf en linksaf slaan',
                'Rotondes',
                'Invoegen en uitvoegen',
                'Inhalen en voorbijgaan',
            ],
            'Bijzondere verrichtingen' => [
                'Achteruit rijden (recht/bocht)',
                'Keren (3 manieren)',
                'Parkeren (vak/file)',
                'Hellingproef',
            ],
            'Veilig en verantwoord rijden' => [
                'Gevaarherkenning',
                'Besluitvaardig rijden',
                'Ruimtekussen en volgafstand',
                'Milieubewust rijden (HNR)',
            ],
        ];

        foreach ($skills as $category => $names) {
            foreach ($names as $name) {
                Skill::firstOrCreate([
                    'category' => $category,
                    'name' => $name
                ]);
            }
        }
    }
}
