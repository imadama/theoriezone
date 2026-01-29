import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:theoriezone_app/api.dart';
import 'package:theoriezone_app/exam_screen.dart';

class ExamSelectionScreen extends StatefulWidget {
  const ExamSelectionScreen({super.key});

  @override
  State<ExamSelectionScreen> createState() => _ExamSelectionScreenState();
}

class _ExamSelectionScreenState extends State<ExamSelectionScreen> {
  bool _isLoading = false;

  Future<void> _startExam(String category) async {
    setState(() => _isLoading = true);

    try {
      final response = await Api.post('/exams/random', {
        'category': category
      });

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (mounted) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ExamScreen(examData: data),
            ),
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
             SnackBar(content: Text('Fout bij starten: ${response.body}')),
          );
        }
      }
    } catch (e) {
      // Error
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Kies Examen')),
      body: _isLoading 
        ? const Center(child: CircularProgressIndicator()) 
        : Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                "Wat wil je oefenen?",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              
              _buildCard(
                title: "Volledig Examen",
                subtitle: "Mix van alle onderdelen (50 vragen)",
                icon: Icons.directions_car,
                color: Colors.deepPurple,
                onTap: () => _startExam('all'),
              ),
              const SizedBox(height: 16),
              
              _buildCard(
                title: "Gevaarherkenning",
                subtitle: "Remmen, loslaten of niets doen",
                icon: Icons.warning_amber_rounded,
                color: Colors.orange,
                onTap: () => _startExam('Gevaarherkenning'),
              ),
              const SizedBox(height: 16),
              
              _buildCard(
                title: "Verkeersregels",
                subtitle: "Kennis van regels en borden",
                icon: Icons.menu_book,
                color: Colors.blue,
                onTap: () => _startExam('Verkeersregels'), // Assuming scraped data has this tag
              ),
              const SizedBox(height: 16),
              
              _buildCard(
                title: "Verkeersinzicht",
                subtitle: "Wat is wijsheid in deze situatie?",
                icon: Icons.visibility,
                color: Colors.green,
                onTap: () => _startExam('Inzicht'),
              ),

            ],
          ),
        ),
    );
  }

  Widget _buildCard({required String title, required String subtitle, required IconData icon, required Color color, required VoidCallback onTap}) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: 32),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Text(subtitle, style: const TextStyle(color: Colors.grey)),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}
