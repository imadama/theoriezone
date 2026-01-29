<!DOCTYPE html>
<html lang="nl">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Voortgang {{ $student->name }}</title>
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-gray-100 p-8">

    <div class="max-w-4xl mx-auto">
        <div class="flex justify-between items-center mb-6">
            <div>
                <h1 class="text-3xl font-bold">{{ $student->name }}</h1>
                <p class="text-gray-600">{{ $student->email }}</p>
            </div>
            <a href="{{ route('school.dashboard') }}" class="text-gray-500 hover:text-gray-700 font-semibold">← Terug naar Dashboard</a>
        </div>

        <div class="bg-white shadow rounded-lg overflow-hidden">
            <div class="px-6 py-4 border-b bg-gray-50">
                <h2 class="text-lg font-bold text-gray-700">Gemaakte Examens</h2>
            </div>
            
            <table class="min-w-full leading-normal">
                <thead>
                    <tr>
                        <th class="px-5 py-3 border-b-2 bg-gray-50 text-left text-xs font-semibold text-gray-600 uppercase">Datum</th>
                        <th class="px-5 py-3 border-b-2 bg-gray-50 text-left text-xs font-semibold text-gray-600 uppercase">Examen</th>
                        <th class="px-5 py-3 border-b-2 bg-gray-50 text-left text-xs font-semibold text-gray-600 uppercase">Score</th>
                        <th class="px-5 py-3 border-b-2 bg-gray-50 text-left text-xs font-semibold text-gray-600 uppercase">Resultaat</th>
                    </tr>
                </thead>
                <tbody>
                    @foreach($attempts as $attempt)
                    <tr>
                        <td class="px-5 py-5 border-b border-gray-200 bg-white text-sm">
                            {{ $attempt->created_at->format('d-m-Y H:i') }}
                        </td>
                        <td class="px-5 py-5 border-b border-gray-200 bg-white text-sm">
                            {{ $attempt->exam->title ?? 'Oefenexamen' }}
                        </td>
                        <td class="px-5 py-5 border-b border-gray-200 bg-white text-sm">
                            <span class="font-bold">{{ $attempt->score }}</span> / 50
                        </td>
                        <td class="px-5 py-5 border-b border-gray-200 bg-white text-sm">
                            @if($attempt->passed)
                                <span class="bg-green-100 text-green-800 px-2 py-1 rounded text-xs font-bold">Geslaagd</span>
                            @else
                                <span class="bg-red-100 text-red-800 px-2 py-1 rounded text-xs font-bold">Gezakt</span>
                            @endif
                        </td>
                    </tr>
                    @endforeach
                </tbody>
            </table>
             @if($attempts->isEmpty())
                <div class="p-8 text-center text-gray-500">Deze leerling heeft nog geen examens gemaakt.</div>
            @endif
        </div>
    </div>

</body>
</html>
