import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:theoriezone_app/api.dart';
import 'package:theoriezone_app/auth_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _isLoading = true;
  List<dynamic> _attempts = [];
  Map<String, dynamic>? _user;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      // 1. Get User info (we could store this globally, but fetch is fine for now)
      final userRes = await Api.get('/user');
      if (userRes.statusCode == 200) {
        _user = jsonDecode(userRes.body);
      }

      // 2. Get Attempts
      final attemptRes = await Api.get('/attempts');
      if (attemptRes.statusCode == 200) {
        _attempts = jsonDecode(attemptRes.body);
      }
    } catch (e) {
      // Handle error
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _logout() async {
    await Api.setToken(""); 
    if (mounted) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const AuthScreen()),
        (route) => false
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) return const Scaffold(body: Center(child: CircularProgressIndicator()));

    return Scaffold(
      appBar: AppBar(title: const Text('Profiel')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // User Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.deepPurple.shade100,
                      child: Text(
                        _user?['name']?[0].toUpperCase() ?? 'U',
                        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.deepPurple),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(_user?['name'] ?? 'Gebruiker', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        Text(_user?['email'] ?? '', style: const TextStyle(color: Colors.grey)),
                      ],
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            
            // Stats
            const Text("Mijn Resultaten", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            
            if (_attempts.isEmpty)
              const Center(child: Padding(padding: EdgeInsets.all(24), child: Text("Nog geen examens gemaakt.")))
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _attempts.length,
                itemBuilder: (context, index) {
                  final attempt = _attempts[index];
                  final passed = attempt['passed'] == true;
                  final score = attempt['score'];

                  return Card(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: ListTile(
                      leading: Icon(
                        passed ? Icons.check_circle : Icons.cancel,
                        color: passed ? Colors.green : Colors.red,
                      ),
                      title: Text(attempt['exam_title']),
                      subtitle: Text(attempt['date']),
                      trailing: Text(
                        passed ? "Geslaagd ($score)" : "Gezakt ($score)",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: passed ? Colors.green : Colors.red
                        ),
                      ),
                    ),
                  );
                },
              ),

            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: _logout,
                icon: const Icon(Icons.logout),
                label: const Text("Uitloggen"),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.red,
                  side: const BorderSide(color: Colors.red),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
