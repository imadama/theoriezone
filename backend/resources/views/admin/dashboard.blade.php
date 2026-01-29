<!DOCTYPE html>
<html lang="nl">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Super Admin Dashboard</title>
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-gray-100 p-8">

    <div class="max-w-7xl mx-auto">
        <div class="flex justify-between items-center mb-8">
            <h1 class="text-3xl font-bold text-gray-800">Platform Beheer</h1>
            <div class="flex space-x-4">
                <a href="{{ route('admin.index') }}" class="bg-gray-600 text-white px-4 py-2 rounded hover:bg-gray-700">Content Editor</a>
                <form action="{{ route('logout.web') }}" method="POST" class="inline">
                    @csrf
                    <button type="submit" class="text-red-600 font-semibold hover:text-red-800 px-4 py-2">Uitloggen</button>
                </form>
            </div>
        </div>

        <!-- Stats Cards -->
        <div class="grid grid-cols-1 md:grid-cols-4 gap-6 mb-8">
            <div class="bg-white p-6 rounded shadow border-l-4 border-indigo-500">
                <div class="text-gray-500">Aantal Rijscholen</div>
                <div class="text-3xl font-bold">{{ $stats['total_schools'] }}</div>
            </div>
            <div class="bg-white p-6 rounded shadow border-l-4 border-green-500">
                <div class="text-gray-500">Totaal Studenten</div>
                <div class="text-3xl font-bold">{{ $stats['total_students'] }}</div>
            </div>
            <div class="bg-white p-6 rounded shadow border-l-4 border-blue-500">
                <div class="text-gray-500">Gemaakte Examens</div>
                <div class="text-3xl font-bold">{{ $stats['total_exams'] }}</div>
            </div>
            <div class="bg-white p-6 rounded shadow border-l-4 border-purple-500">
                <div class="text-gray-500">Examens Vandaag</div>
                <div class="text-3xl font-bold">{{ $stats['exams_today'] }}</div>
            </div>
        </div>

        @if(session('success'))
            <div class="bg-green-100 border border-green-400 text-green-700 px-4 py-3 rounded mb-6">
                {{ session('success') }}
            </div>
        @endif

        <!-- Schools List -->
        <div class="bg-white shadow rounded-lg overflow-hidden">
            <div class="px-6 py-4 border-b bg-gray-50 flex justify-between items-center">
                <h2 class="text-xl font-bold text-gray-700">Aangesloten Rijscholen</h2>
                <a href="{{ route('admin.school.create') }}" class="bg-indigo-600 text-white px-4 py-2 rounded text-sm hover:bg-indigo-700 font-bold">
                    + Rijschool Toevoegen
                </a>
            </div>
            
            <table class="min-w-full leading-normal">
                <thead>
                    <tr>
                        <th class="px-5 py-3 border-b-2 bg-gray-50 text-left text-xs font-semibold text-gray-600 uppercase">Naam Rijschool</th>
                        <th class="px-5 py-3 border-b-2 bg-gray-50 text-left text-xs font-semibold text-gray-600 uppercase">Email</th>
                        <th class="px-5 py-3 border-b-2 bg-gray-50 text-left text-xs font-semibold text-gray-600 uppercase">Aantal Leerlingen</th>
                        <th class="px-5 py-3 border-b-2 bg-gray-50 text-left text-xs font-semibold text-gray-600 uppercase">Lid Sinds</th>
                        <th class="px-5 py-3 border-b-2 bg-gray-50 text-left text-xs font-semibold text-gray-600 uppercase">Actie</th>
                    </tr>
                </thead>
                <tbody>
                    @foreach($schools as $school)
                    <tr>
                        <td class="px-5 py-5 border-b border-gray-200 bg-white text-sm font-bold text-gray-900">
                            {{ $school->name }}
                        </td>
                        <td class="px-5 py-5 border-b border-gray-200 bg-white text-sm text-gray-600">
                            {{ $school->email }}
                        </td>
                        <td class="px-5 py-5 border-b border-gray-200 bg-white text-sm">
                            <span class="bg-blue-100 text-blue-800 px-2 py-1 rounded text-xs font-bold">
                                {{ $school->students_count }} leerlingen
                            </span>
                        </td>
                        <td class="px-5 py-5 border-b border-gray-200 bg-white text-sm text-gray-600">
                            {{ $school->created_at->format('d-m-Y') }}
                        </td>
                        <td class="px-5 py-5 border-b border-gray-200 bg-white text-sm">
                            <!-- Future: Login as school, edit school, delete school -->
                            <button class="text-indigo-600 hover:text-indigo-900 cursor-not-allowed opacity-50" title="Binnenkort">Bewerk</button>
                        </td>
                    </tr>
                    @endforeach
                </tbody>
            </table>
            @if($schools->isEmpty())
                <div class="p-8 text-center text-gray-500">Nog geen rijscholen aangemaakt.</div>
            @endif
        </div>
    </div>

</body>
</html>
