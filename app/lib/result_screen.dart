import 'package:flutter/material.dart';
import 'package:theoriezone_app/review_screen.dart';

class ResultScreen extends StatelessWidget {
  final Map<String, dynamic> result;

  const ResultScreen({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    final bool passed = result['passed'] == true;
    final int score = result['score'];
    final int total = result['total'];
    final dynamic grade = result['grade'];
    final List<dynamic> mistakes = result['mistakes'] ?? [];

    return Scaffold(
      appBar: AppBar(title: const Text('Resultaat'), automaticallyImplyLeading: false),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                passed ? Icons.check_circle : Icons.cancel,
                size: 100,
                color: passed ? Colors.green : Colors.red,
              ),
              const SizedBox(height: 24),
              Text(
                passed ? 'Geslaagd!' : 'Gezakt',
                style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Text(
                'Je score: $score / $total',
                style: const TextStyle(fontSize: 20, color: Colors.grey),
              ),
              const SizedBox(height: 8),
              Text(
                'Cijfer: $grade',
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w600, color: Colors.deepPurple),
              ),
              const SizedBox(height: 32),
              
              if (mistakes.isNotEmpty)
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context, 
                      MaterialPageRoute(builder: (_) => ReviewScreen(mistakes: mistakes))
                    );
                  },
                  icon: const Icon(Icons.warning_amber_rounded),
                  label: Text('Bekijk ${mistakes.length} fouten'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amber.shade100,
                    foregroundColor: Colors.brown,
                  ),
                ),

              const SizedBox(height: 16),
              OutlinedButton(
                onPressed: () {
                  Navigator.of(context).popUntil((route) => route.isFirst);
                },
                child: const Text('Terug naar Home'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
