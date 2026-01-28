import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:theoriezone_app/api.dart';

class ExamScreen extends StatefulWidget {
  final int? examId;
  final Map<String, dynamic>? examData; // Direct data (for random exam)

  const ExamScreen({super.key, this.examId, this.examData});

  @override
  State<ExamScreen> createState() => _ExamScreenState();
}

class _ExamScreenState extends State<ExamScreen> {
  Map<String, dynamic>? _exam;
  bool _isLoading = true;
  int _currentIndex = 0;
  final Map<int, int> _answers = {}; 

  @override
  void initState() {
    super.initState();
    if (widget.examData != null) {
      _exam = widget.examData;
      _isLoading = false;
    } else if (widget.examId != null) {
      _fetchExam(widget.examId!);
    }
  }

  Future<void> _fetchExam(int id) async {
    try {
      final response = await Api.get('/exams/$id');
      if (response.statusCode == 200) {
        setState(() {
          _exam = jsonDecode(response.body);
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  void _submitAnswer(int questionId, int index) {
    setState(() {
      _answers[questionId] = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) return const Scaffold(body: Center(child: CircularProgressIndicator()));
    if (_exam == null) return const Scaffold(body: Center(child: Text("Fout bij laden")));

    final questions = _exam!['questions'] as List;
    final currentQ = questions[_currentIndex];

    return Scaffold(
      appBar: AppBar(
        title: Text('Vraag ${_currentIndex + 1}/${questions.length}'),
      ),
      body: Column(
        children: [
          if (currentQ['image_url'] != null)
            Image.network(
              currentQ['image_url'],
              height: 200,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) =>
                  Container(height: 200, color: Colors.grey[200], child: const Icon(Icons.broken_image)),
            ),
          
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(currentQ['text'], style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 20),
                  
                  ...List.generate(currentQ['options'].length, (index) {
                    final option = currentQ['options'][index];
                    final isSelected = _answers[currentQ['id']] == index;
                    
                    return InkWell(
                      onTap: () => _submitAnswer(currentQ['id'], index),
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: isSelected ? Colors.deepPurple.shade50 : Colors.white,
                          border: Border.all(
                            color: isSelected ? Colors.deepPurple : Colors.grey.shade300,
                            width: 2
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
                              color: isSelected ? Colors.deepPurple : Colors.grey,
                            ),
                            const SizedBox(width: 12),
                            Text(option, style: const TextStyle(fontSize: 16)),
                          ],
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),
          
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (_currentIndex > 0)
                  ElevatedButton(
                    onPressed: () => setState(() => _currentIndex--),
                    child: const Text('Vorige'),
                  )
                else
                  const SizedBox(),
                  
                ElevatedButton(
                  onPressed: () {
                    if (_currentIndex < questions.length - 1) {
                      setState(() => _currentIndex++);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Examen afronden...')));
                    }
                  },
                  child: Text(_currentIndex < questions.length - 1 ? 'Volgende' : 'Afronden'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
