<!DOCTYPE html>
<html lang="nl">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Voortgang {{ $student->name }}</title>
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-gray-100 p-8">

    <div class="max-w-6xl mx-auto">
        <div class="flex justify-between items-center mb-6">
            <div>
                <h1 class="text-3xl font-bold">{{ $student->name }}</h1>
                <p class="text-gray-600">{{ $student->email }}</p>
            </div>
            <a href="{{ route('school.dashboard') }}" class="text-gray-500 hover:text-gray-700 font-semibold">← Terug naar Dashboard</a>
        </div>

        @if(session('success'))
            <div class="bg-green-100 text-green-700 p-4 rounded mb-6">{{ session('success') }}</div>
        @endif

        <div class="grid grid-cols-1 lg:grid-cols-2 gap-8">
            
            <!-- Left: Lessons Planner -->
            <div>
                <div class="bg-white shadow rounded-lg p-6 mb-6">
                    <h2 class="text-xl font-bold mb-4">Rijles Inplannen</h2>
                    <form action="{{ route('school.lessons.store') }}" method="POST">
                        @csrf
                        <input type="hidden" name="student_id" value="{{ $student->id }}">
                        
                        <div class="grid grid-cols-2 gap-4 mb-4">
                            <div>
                                <label class="block text-gray-700 text-sm font-bold mb-2">Datum</label>
                                <input type="date" name="date" class="shadow border rounded w-full py-2 px-3" required>
                            </div>
                            <div>
                                <label class="block text-gray-700 text-sm font-bold mb-2">Tijd</label>
                                <input type="time" name="time" class="shadow border rounded w-full py-2 px-3" required>
                            </div>
                        </div>
                        
                        <div class="mb-4">
                            <label class="block text-gray-700 text-sm font-bold mb-2">Duur (minuten)</label>
                            <select name="duration" class="shadow border rounded w-full py-2 px-3">
                                <option value="60" selected>60 minuten</option>
                                <option value="90">90 minuten</option>
                                <option value="120">120 minuten</option>
                            </select>
                        </div>
                        
                        <div class="mb-4">
                            <label class="block text-gray-700 text-sm font-bold mb-2">Notitie</label>
                            <input type="text" name="notes" placeholder="Bijv. Ophalen station" class="shadow border rounded w-full py-2 px-3">
                        </div>

                        <button type="submit" class="bg-indigo-600 text-white font-bold py-2 px-4 rounded w-full hover:bg-indigo-700">
                            Inplannen
                        </button>
                    </form>
                </div>

                <div class="bg-white shadow rounded-lg overflow-hidden">
                    <div class="px-6 py-4 border-b bg-gray-50">
                        <h2 class="text-lg font-bold text-gray-700">Aankomende Lessen</h2>
                    </div>
                    <ul>
                        @foreach($lessons as $lesson)
                            <li class="border-b px-6 py-4 flex justify-between items-center">
                                <div>
                                    <div class="font-bold text-lg">{{ $lesson->start_time->format('d-m-Y') }}</div>
                                    <div class="text-indigo-600 font-semibold">
                                        {{ $lesson->start_time->format('H:i') }} - {{ $lesson->end_time->format('H:i') }}
                                    </div>
                                    @if($lesson->notes)
                                        <div class="text-gray-500 text-sm italic">{{ $lesson->notes }}</div>
                                    @endif
                                </div>
                                <form action="{{ route('school.lessons.destroy', $lesson->id) }}" method="POST" onsubmit="return confirm('Zeker weten?')">
                                    @csrf
                                    @method('DELETE')
                                    <button type="submit" class="text-red-500 hover:text-red-700 text-sm">Annuleren</button>
                                </form>
                            </li>
                        @endforeach
                        @if($lessons->isEmpty())
                            <li class="px-6 py-4 text-gray-500 text-center">Geen lessen gepland.</li>
                        @endif
                    </ul>
                </div>
            </div>

            <!-- Right: Exam Results & Progress -->
            <div class="h-fit space-y-6">
                
                <!-- Progress Card (RIS) -->
                <div class="bg-white shadow rounded-lg overflow-hidden">
                    <div class="px-6 py-4 border-b bg-gray-50 flex justify-between items-center">
                        <h2 class="text-lg font-bold text-gray-700">Vorderingen (RIS)</h2>
                        <button form="progressForm" type="submit" class="text-sm bg-green-600 text-white px-3 py-1 rounded hover:bg-green-700">Opslaan</button>
                    </div>
                    
                    <form id="progressForm" action="{{ route('school.progress.update') }}" method="POST" class="p-4 max-h-96 overflow-y-auto">
                        @csrf
                        <input type="hidden" name="student_id" value="{{ $student->id }}">
                        
                        @foreach($skills as $category => $catSkills)
                            <div class="mb-4">
                                <h3 class="font-bold text-gray-800 mb-2 border-b pb-1">{{ $category }}</h3>
                                @foreach($catSkills as $skill)
                                    <div class="flex justify-between items-center mb-2 text-sm">
                                        <span class="text-gray-600 w-1/2">{{ $skill->name }}</span>
                                        <div class="flex space-x-1">
                                            @for($i = 1; $i <= 5; $i++)
                                                <label class="cursor-pointer">
                                                    <input type="radio" name="progress[{{ $skill->id }}]" value="{{ $i }}" {{ ($progress[$skill->id] ?? 0) == $i ? 'checked' : '' }} class="hidden peer">
                                                    <span class="w-6 h-6 rounded-full border flex items-center justify-center peer-checked:bg-yellow-400 peer-checked:text-white hover:bg-gray-100">
                                                        {{ $i }}
                                                    </span>
                                                </label>
                                            @endfor
                                        </div>
                                    </div>
                                @endforeach
                            </div>
                        @endforeach
                    </form>
                </div>

                <!-- Theory Results -->
                <div class="bg-white shadow rounded-lg overflow-hidden">
                    <div class="px-6 py-4 border-b bg-gray-50">
                        <h2 class="text-lg font-bold text-gray-700">Theorie Resultaten</h2>
                    </div>
                
                <table class="min-w-full leading-normal">
                    <thead>
                        <tr>
                            <th class="px-4 py-2 border-b-2 bg-gray-50 text-left text-xs font-semibold text-gray-600 uppercase">Datum</th>
                            <th class="px-4 py-2 border-b-2 bg-gray-50 text-left text-xs font-semibold text-gray-600 uppercase">Score</th>
                            <th class="px-4 py-2 border-b-2 bg-gray-50 text-left text-xs font-semibold text-gray-600 uppercase">Status</th>
                        </tr>
                    </thead>
                    <tbody>
                        @foreach($attempts as $attempt)
                        <tr>
                            <td class="px-4 py-3 border-b border-gray-200 text-sm">
                                {{ $attempt->created_at->format('d-m-Y H:i') }}
                            </td>
                            <td class="px-4 py-3 border-b border-gray-200 text-sm">
                                <b>{{ $attempt->score }}</b>/50
                            </td>
                            <td class="px-4 py-3 border-b border-gray-200 text-sm">
                                @if($attempt->passed)
                                    <span class="text-green-600 font-bold">Geslaagd</span>
                                @else
                                    <span class="text-red-600 font-bold">Gezakt</span>
                                @endif
                            </td>
                        </tr>
                        @endforeach
                    </tbody>
                </table>
                 @if($attempts->isEmpty())
                    <div class="p-8 text-center text-gray-500">Nog geen theorie examens gemaakt.</div>
                @endif
            </div>

        </div>
    </div>

</body>
</html>
