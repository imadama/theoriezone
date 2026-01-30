import 'package:flutter/material.dart';
import 'package:theoriezone_app/api.dart';
import 'package:theoriezone_app/theme.dart';
import 'dart:convert';

class ProgressScreen extends StatefulWidget {
  const ProgressScreen({super.key});

  @override
  State<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen> {
  List<dynamic> _categories = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchProgress();
  }

  Future<void> _fetchProgress() async {
    try {
      final res = await Api.get('/progress');
      if (res.statusCode == 200) {
        setState(() {
          _categories = jsonDecode(res.body);
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mijn Voortgang (RIS)')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _categories.isEmpty
              ? const Center(child: Text("Nog geen beoordelingen."))
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _categories.length,
                  itemBuilder: (context, index) {
                    final cat = _categories[index];
                    final skills = cat['skills'] as List;

                    return Card(
                      margin: const EdgeInsets.only(bottom: 24),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              cat['category'],
                              style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primary),
                            ),
                            const Divider(),
                            ...skills.map((skill) {
                              final score = skill['score'] as int;
                              return Padding(
                                padding: const EdgeInsets.symmetric(vertical: 8),
                                child: Row(
                                  children: [
                                    Expanded(
                                      flex: 4,
                                      child: Text(skill['name'],
                                          style: const TextStyle(fontSize: 15)),
                                    ),
                                    Expanded(
                                      flex: 3,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: List.generate(5, (i) {
                                          return Icon(
                                            Icons.star_rounded,
                                            size: 20,
                                            color: i < score
                                                ? Colors.amber
                                                : Colors.grey.shade300,
                                          );
                                        }),
                                      ),
                                    )
                                  ],
                                ),
                              );
                            }).toList(),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
