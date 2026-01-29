<!DOCTYPE html>
<html lang="nl">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Nieuwe Leerling</title>
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-gray-100 p-8 flex justify-center">

    <div class="bg-white p-8 rounded shadow-md w-full max-w-lg">
        <h1 class="text-2xl font-bold mb-6">Nieuwe Leerling Toevoegen</h1>
        
        <form action="{{ route('school.store') }}" method="POST">
            @csrf
            <div class="mb-4">
                <label class="block text-gray-700 font-bold mb-2">Naam Leerling</label>
                <input type="text" name="name" class="shadow appearance-none border rounded w-full py-2 px-3 text-gray-700" required>
            </div>

            <div class="mb-4">
                <label class="block text-gray-700 font-bold mb-2">Email Adres</label>
                <input type="email" name="email" class="shadow appearance-none border rounded w-full py-2 px-3 text-gray-700" required>
            </div>
            
            <div class="mb-6">
                <label class="block text-gray-700 font-bold mb-2">Wachtwoord (Tijdelijk)</label>
                <input type="text" name="password" value="Welkom123" class="shadow appearance-none border rounded w-full py-2 px-3 text-gray-700 bg-gray-50" required>
                <p class="text-xs text-gray-500 mt-1">Geef dit wachtwoord aan de leerling.</p>
            </div>

            <div class="flex justify-between items-center">
                <a href="{{ route('school.dashboard') }}" class="text-gray-600 hover:text-gray-900">Annuleren</a>
                <button type="submit" class="bg-indigo-600 text-white font-bold py-2 px-6 rounded hover:bg-indigo-700">
                    Aanmaken
                </button>
            </div>
        </form>
    </div>

</body>
</html>
