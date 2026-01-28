import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:theoriezone_app/api.dart';
import 'package:theoriezone_app/exam_screen.dart';

class ExamListScreen extends StatefulWidget {
  const ExamListScreen({super.key});

  @override
  State<ExamListScreen> createState() => _ExamListScreenState();
}

class _ExamListScreenState extends State<ExamListScreen> {
  List<dynamic> _exams = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchExams();
  }

  Future<void> _fetchExams() async {
    try {
      final response = await Api.get('/exams');
      if (response.statusCode == 200) {
        setState(() {
          _exams = jsonDecode(response.body);
          _isLoading = false;
        });
      }
    } catch (e) {
      // Handle error
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Kies een examen')),
      body: ListView.builder(
        itemCount: _exams.length,
        itemBuilder: (context, index) {
          final exam = _exams[index];
          return Card(
            margin: const EdgeInsets.all(8),
            child: ListTile(
              leading: const Icon(Icons.drive_eta, color: Colors.deepPurple),
              title: Text(exam['title']),
              subtitle: Text('${exam['total_questions']} vragen • ${exam['duration_minutes']} min'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ExamScreen(examId: exam['id']),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
