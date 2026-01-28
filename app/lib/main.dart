import 'package:flutter/material.dart';
import 'package:theoriezone_app/paywall_screen.dart';
import 'package:theoriezone_app/api.dart';
import 'package:theoriezone_app/exam_list_screen.dart';
import 'dart:convert';

void main() {
  runApp(const TheorieZoneApp());
}

class TheorieZoneApp extends StatelessWidget {
  const TheorieZoneApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TheorieZone',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _hasAccess = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _checkAccess();
  }

  Future<void> _checkAccess() async {
    try {
      // Check entitlements via backend
      final res = await Api.get('/entitlements/check');
      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        if (mounted) {
          setState(() {
            _hasAccess = data['active'] == true;
            _isLoading = false;
          });
        }
        return;
      }
    } catch (e) {
      // Network error, fallthrough
    }
    
    if (mounted) {
      setState(() {
        _hasAccess = false; 
        _isLoading = false;
      });
    }
  }

  void _showPaywall() async {
    final result = await Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const PaywallScreen()),
    );

    if (result == true) {
      setState(() {
        _hasAccess = true;
        _isLoading = true; // Re-check to be sure or just switch
      });
      _checkAccess();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (_hasAccess) {
      return const ExamListScreen();
    }

    return Scaffold(
      appBar: AppBar(title: const Text('TheorieZone')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.school_outlined, size: 80, color: Colors.deepPurple),
            const SizedBox(height: 24),
            const Text(
              'Welkom bij TheorieZone',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            const Text('Je hebt nog geen toegang tot de cursus.', style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: _showPaywall,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              ),
              child: const Text('Cursus ontgrendelen'),
            ),
          ],
        ),
      ),
    );
  }
}
