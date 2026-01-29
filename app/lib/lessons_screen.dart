import 'package:flutter/material.dart';
import 'package:theoriezone_app/api.dart';
import 'package:theoriezone_app/theme.dart';
import 'dart:convert';
import 'package:intl/intl.dart'; // We assume intl is available or handle formatting manually

class LessonsScreen extends StatefulWidget {
  const LessonsScreen({super.key});

  @override
  State<LessonsScreen> createState() => _LessonsScreenState();
}

class _LessonsScreenState extends State<LessonsScreen> {
  List<dynamic> _lessons = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchLessons();
  }

  Future<void> _fetchLessons() async {
    try {
      final res = await Api.get('/lessons');
      if (res.statusCode == 200) {
        setState(() {
          _lessons = jsonDecode(res.body);
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  String _formatDate(String iso) {
    try {
      final dt = DateTime.parse(iso);
      return "${dt.day}-${dt.month}-${dt.year}";
    } catch (e) {
      return iso;
    }
  }
  
  String _formatTime(String iso) {
    try {
      final dt = DateTime.parse(iso);
      final hour = dt.hour.toString().padLeft(2, '0');
      final minute = dt.minute.toString().padLeft(2, '0');
      return "$hour:$minute";
    } catch (e) {
      return "";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mijn Rijlessen')),
      body: _isLoading 
        ? const Center(child: CircularProgressIndicator()) 
        : _lessons.isEmpty 
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.calendar_today, size: 80, color: Colors.grey.shade300),
                  const SizedBox(height: 16),
                  const Text("Nog geen lessen gepland.", style: TextStyle(color: Colors.grey)),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _lessons.length,
              itemBuilder: (context, index) {
                final lesson = _lessons[index];
                final start = lesson['start_time'];
                final end = lesson['end_time'];
                final notes = lesson['notes'];
                final instructor = lesson['instructor']?['name'] ?? 'Instructeur';

                return Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Date Box
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            children: [
                              Text(
                                _formatDate(start).split('-')[0], // Day
                                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.primary),
                              ),
                              Text(
                                "MND", // Simplification
                                style: const TextStyle(fontSize: 12, color: AppColors.primary),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
                        
                        // Info
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Rijles met $instructor",
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                "${_formatTime(start)} - ${_formatTime(end)}",
                                style: const TextStyle(color: AppColors.textDark, fontWeight: FontWeight.w500),
                              ),
                              if (notes != null && notes.toString().isNotEmpty) ...[
                                const SizedBox(height: 8),
                                Text(notes, style: const TextStyle(color: Colors.grey, fontStyle: FontStyle.italic)),
                              ]
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
