import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:theoriezone_app/api.dart';
import 'package:theoriezone_app/result_screen.dart';

class ExamScreen extends StatefulWidget {
  final int? examId;
  final Map<String, dynamic>? examData;

  const ExamScreen({super.key, this.examId, this.examData});

  @override
  State<ExamScreen> createState() => _ExamScreenState();
}

class _ExamScreenState extends State<ExamScreen> {
  Map<String, dynamic>? _exam;
  bool _isLoading = true;
  bool _isSubmitting = false;
  int _currentIndex = 0;
  final Map<int, int> _answers = {}; 
  int? _attemptId;
  
  // Timer vars
  Timer? _timer;
  int _secondsRemaining = 0;

  @override
  void initState() {
    super.initState();
    if (widget.examData != null) {
      _initExam(widget.examData!);
    } else if (widget.examId != null) {
      _fetchExam(widget.examId!);
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _initExam(Map<String, dynamic> data) {
    setState(() {
      _exam = data;
      _attemptId = data['attempt_id'];
      _isLoading = false;
      // Init timer (default 30 mins if not provided)
      int duration = data['duration_minutes'] ?? 30;
      _secondsRemaining = duration * 60;
    });
    _startTimer();
  }

  Future<void> _fetchExam(int id) async {
    try {
      final response = await Api.get('/exams/$id');
      if (response.statusCode == 200) {
        _initExam(jsonDecode(response.body));
      }
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 0) {
        setState(() => _secondsRemaining--);
      } else {
        _timer?.cancel();
        _timeExpired();
      }
    });
  }

  void _timeExpired() {
    if (_isSubmitting) return;
    
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: const Text("Tijd is op!"),
        content: const Text("Je examen wordt nu ingeleverd."),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("OK"))
        ],
      ),
    ).then((_) => _submitExam());
  }

  String get _timerString {
    final minutes = (_secondsRemaining / 60).floor().toString().padLeft(2, '0');
    final seconds = (_secondsRemaining % 60).toString().padLeft(2, '0');
    return "$minutes:$seconds";
  }

  Future<void> _submitExam() async {
    if (_isSubmitting) return;
    _timer?.cancel();
    setState(() => _isSubmitting = true);

    final id = _attemptId ?? 1; 

    try {
      final response = await Api.post('/exams/$id/submit', {
        'answers': _answers
      });

      if (response.statusCode == 200) {
        final result = jsonDecode(response.body);
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => ResultScreen(result: result)),
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
             SnackBar(content: Text('Fout bij inleveren: ${response.body}')),
          );
        }
      }
    } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
        }
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
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

    // Timer color gets red when < 5 mins
    final timerColor = _secondsRemaining < 300 ? Colors.red : Colors.white;

    return Scaffold(
      appBar: AppBar(
        title: Text('Vraag ${_currentIndex + 1}/${questions.length}'),
        actions: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            margin: const EdgeInsets.only(right: 16),
            decoration: BoxDecoration(
              color: _secondsRemaining < 300 ? Colors.red.shade100 : Colors.deepPurple.shade50,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: _secondsRemaining < 300 ? Colors.red : Colors.deepPurple),
            ),
            child: Row(
              children: [
                Icon(Icons.timer, size: 16, color: _secondsRemaining < 300 ? Colors.red : Colors.deepPurple),
                const SizedBox(width: 4),
                Text(
                  _timerString,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: _secondsRemaining < 300 ? Colors.red : Colors.deepPurple,
                    fontFeatures: const [FontFeature.tabularFigures()], // Fixed width numbers
                  ),
                ),
              ],
            ),
          )
        ],
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
                      _submitExam();
                    }
                  },
                  child: _isSubmitting 
                    ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                    : Text(_currentIndex < questions.length - 1 ? 'Volgende' : 'Afronden'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
