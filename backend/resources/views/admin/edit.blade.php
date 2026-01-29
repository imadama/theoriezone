<!DOCTYPE html>
<html lang="nl">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Edit Vraag #{{ $question->id }}</title>
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-gray-100 p-8">

    <div class="max-w-2xl mx-auto bg-white p-8 rounded shadow">
        <div class="flex justify-between items-center mb-6">
            <h1 class="text-2xl font-bold">Bewerk Vraag #{{ $question->id }}</h1>
            <a href="{{ route('admin.index') }}" class="text-gray-500 hover:text-gray-700">Terug</a>
        </div>

        @if($question->image_path)
            <div class="mb-6">
                <img src="{{ str_starts_with($question->image_path, 'http') ? $question->image_path : 'http://localhost:8080' . $question->image_path }}" 
                     alt="Vraag afbeelding" 
                     class="w-full h-64 object-contain bg-gray-50 rounded border">
            </div>
        @endif

        <form action="{{ route('admin.update', $question->id) }}" method="POST">
            @csrf
            
            <div class="mb-4">
                <label class="block text-gray-700 text-sm font-bold mb-2">Vraag Tekst</label>
                <textarea name="text" rows="3" class="shadow appearance-none border rounded w-full py-2 px-3 text-gray-700 leading-tight focus:outline-none focus:shadow-outline">{{ $question->text }}</textarea>
            </div>

            <div class="mb-4">
                <label class="block text-gray-700 text-sm font-bold mb-2">Categorie</label>
                <input type="text" name="category" value="{{ $question->category }}" class="shadow appearance-none border rounded w-full py-2 px-3 text-gray-700">
            </div>

            <div class="mb-6">
                <label class="block text-gray-700 text-sm font-bold mb-2">Antwoorden</label>
                <div class="space-y-3">
                    @php $options = $question->options ?? ['', '', '']; @endphp
                    @foreach($options as $index => $opt)
                        <div class="flex items-center">
                            <input type="radio" name="correct_index" value="{{ $index }}" {{ $question->correct_index == $index ? 'checked' : '' }} class="mr-2 h-4 w-4 text-indigo-600">
                            <input type="text" name="options[]" value="{{ $opt }}" class="flex-1 shadow appearance-none border rounded py-2 px-3 text-gray-700" placeholder="Antwoord optie {{ $index+1 }}">
                        </div>
                    @endforeach
                    <!-- Add functionality to add more options dynamically later if needed, for now stick to current count or 3 -->
                    @if(count($options) < 2)
                        <div class="flex items-center">
                            <input type="radio" name="correct_index" value="1" class="mr-2">
                            <input type="text" name="options[]" value="" class="flex-1 shadow appearance-none border rounded py-2 px-3 text-gray-700" placeholder="Extra optie">
                        </div>
                    @endif
                </div>
                <p class="text-xs text-gray-500 mt-1">Selecteer het bolletje voor het juiste antwoord.</p>
            </div>

            <div class="mb-6">
                <label class="block text-gray-700 text-sm font-bold mb-2">Uitleg (Optioneel)</label>
                <textarea name="explanation" rows="3" class="shadow appearance-none border rounded w-full py-2 px-3 text-gray-700 leading-tight">{{ $question->explanation }}</textarea>
            </div>

            <div class="flex items-center justify-between">
                <button type="submit" class="bg-indigo-600 hover:bg-indigo-700 text-white font-bold py-2 px-4 rounded focus:outline-none focus:shadow-outline">
                    Opslaan
                </button>
                
                <!-- Quick Next button logic could go here -->
            </div>
        </form>
    </div>

</body>
</html>
