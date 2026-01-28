import 'package:flutter/material.dart';

class ReviewScreen extends StatelessWidget {
  final List<dynamic> mistakes;

  const ReviewScreen({super.key, required this.mistakes});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Fouten Inzien')),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: mistakes.length,
        itemBuilder: (context, index) {
          final m = mistakes[index];
          final options = m['options'] as List;
          final yourIdx = m['your_answer_index'];
          final correctIdx = m['correct_index'];

          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Image (optional)
                  if (m['image_url'] != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Image.network(
                        m['image_url'],
                        height: 150,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (_,__,___) => const SizedBox(),
                      ),
                    ),

                  // Question
                  Text(
                    'Vraag ${index + 1}: ${m['text']}',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 12),

                  // Answers
                  ...List.generate(options.length, (optIndex) {
                    final isCorrect = optIndex == correctIdx;
                    final isWronglyChosen = optIndex == yourIdx && !isCorrect;
                    
                    Color? bgColor;
                    if (isCorrect) bgColor = Colors.green.shade50;
                    if (isWronglyChosen) bgColor = Colors.red.shade50;

                    IconData? icon;
                    if (isCorrect) icon = Icons.check_circle;
                    if (isWronglyChosen) icon = Icons.cancel;

                    return Container(
                      margin: const EdgeInsets.only(bottom: 4),
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: bgColor,
                        borderRadius: BorderRadius.circular(4),
                        border: bgColor != null ? Border.all(color: isCorrect ? Colors.green : Colors.red) : null
                      ),
                      child: Row(
                        children: [
                          if (icon != null) ...[
                            Icon(icon, size: 16, color: isCorrect ? Colors.green : Colors.red),
                            const SizedBox(width: 8),
                          ],
                          Expanded(child: Text(options[optIndex].toString())),
                        ],
                      ),
                    );
                  }),

                  // Explanation
                  if (m['explanation'] != null) ...[
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(12),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.amber.shade50,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Uitleg:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                          Text(m['explanation'], style: const TextStyle(fontSize: 14)),
                        ],
                      ),
                    ),
                  ]
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
