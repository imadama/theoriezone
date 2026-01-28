import 'package:flutter/material.dart';

class ResultScreen extends StatelessWidget {
  final Map<String, dynamic> result;

  const ResultScreen({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    final bool passed = result['passed'] == true;
    final int score = result['score'];
    final int total = result['total'];
    final dynamic grade = result['grade'];

    return Scaffold(
      appBar: AppBar(title: const Text('Resultaat')),
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
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600, color: Colors.deepPurple),
              ),
              const SizedBox(height: 48),
              ElevatedButton(
                onPressed: () {
                  // Pop until home
                  Navigator.of(context).popUntil((route) => route.isFirst);
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                ),
                child: const Text('Terug naar Home'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
