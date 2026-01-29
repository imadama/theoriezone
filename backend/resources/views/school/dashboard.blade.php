<!DOCTYPE html>
<html lang="nl">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Rijschool Dashboard</title>
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-gray-100 p-8">

    <div class="max-w-6xl mx-auto">
        <div class="flex justify-between items-center mb-8">
            <h1 class="text-3xl font-bold">Mijn Leerlingen</h1>
            <div>
                 <span class="mr-4 text-gray-600">Welkom, {{ Auth::user()->name }}</span>
                 <a href="{{ route('school.create') }}" class="bg-indigo-600 text-white px-4 py-2 rounded hover:bg-indigo-700">Nieuwe Leerling</a>
            </div>
        </div>

        @if(session('success'))
            <div class="bg-green-100 text-green-700 p-4 rounded mb-6">{{ session('success') }}</div>
        @endif

        <div class="bg-white shadow rounded-lg overflow-hidden">
            <table class="min-w-full leading-normal">
                <thead>
                    <tr>
                        <th class="px-5 py-3 border-b-2 bg-gray-50 text-left text-xs font-semibold text-gray-600 uppercase">Naam</th>
                        <th class="px-5 py-3 border-b-2 bg-gray-50 text-left text-xs font-semibold text-gray-600 uppercase">Email</th>
                        <th class="px-5 py-3 border-b-2 bg-gray-50 text-left text-xs font-semibold text-gray-600 uppercase">Geslaagde Examens</th>
                        <th class="px-5 py-3 border-b-2 bg-gray-50 text-left text-xs font-semibold text-gray-600 uppercase">Actie</th>
                    </tr>
                </thead>
                <tbody>
                    @foreach($students as $student)
                    <tr>
                        <td class="px-5 py-5 border-b border-gray-200 bg-white text-sm">
                            <p class="text-gray-900 font-bold">{{ $student->name }}</p>
                        </td>
                        <td class="px-5 py-5 border-b border-gray-200 bg-white text-sm">
                            <p class="text-gray-900">{{ $student->email }}</p>
                        </td>
                        <td class="px-5 py-5 border-b border-gray-200 bg-white text-sm">
                            <span class="bg-green-100 text-green-800 px-2 py-1 rounded text-xs font-bold">
                                {{ $student->passed_exams }}
                            </span>
                        </td>
                        <td class="px-5 py-5 border-b border-gray-200 bg-white text-sm">
                            <a href="{{ route('school.student', $student->id) }}" class="text-indigo-600 hover:text-indigo-900 font-semibold">Bekijk Voortgang</a>
                        </td>
                    </tr>
                    @endforeach
                </tbody>
            </table>
            @if($students->isEmpty())
                <div class="p-8 text-center text-gray-500">Nog geen leerlingen toegevoegd.</div>
            @endif
        </div>
    </div>
</body>
</html>
