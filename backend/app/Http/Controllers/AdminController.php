<?php

namespace App\Http\Controllers;

use App\Models\Question;
use Illuminate\Http\Request;

class AdminController extends Controller
{
    public function index(Request $request)
    {
        $query = Question::query();

        // Filter: Show 'todo' first (questions with default answers)
        // Assuming default options are json encoded ["Ja","Nee"] which is length ~13 chars
        // Or check if 'options' contains only 2 elements.
        
        $filter = $request->get('filter', 'all');
        
        if ($filter === 'todo') {
             // Rough check for "Ja/Nee" questions
            $query->where('options', 'like', '%"Ja"%'); 
        }

        $questions = $query->paginate(20);

        return view('admin.index', compact('questions'));
    }

    public function edit($id)
    {
        $question = Question::findOrFail($id);
        return view('admin.edit', compact('question'));
    }

    public function update(Request $request, $id)
    {
        $question = Question::findOrFail($id);

        $data = $request->validate([
            'text' => 'required|string',
            'options' => 'required|array',
            'correct_index' => 'required|integer',
            'explanation' => 'nullable|string',
            'category' => 'nullable|string',
        ]);

        // Fix options keys to be pure array
        $data['options'] = array_values($data['options']);

        $question->update($data);

        return redirect()->route('admin.index')->with('success', 'Vraag bijgewerkt!');
    }
}
