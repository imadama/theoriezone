import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:theoriezone_app/paywall_screen.dart';
import 'package:theoriezone_app/api.dart';
import 'package:theoriezone_app/exam_list_screen.dart';
import 'package:theoriezone_app/auth_screen.dart';
import 'package:theoriezone_app/profile_screen.dart';
import 'package:theoriezone_app/onboarding_screen.dart';
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
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const StartupScreen(),
    );
  }
}

class StartupScreen extends StatefulWidget {
  const StartupScreen({super.key});

  @override
  State<StartupScreen> createState() => _StartupScreenState();
}

class _StartupScreenState extends State<StartupScreen> {
  @override
  void initState() {
    super.initState();
    _checkSession();
  }

  Future<void> _checkSession() async {
    // 1. Check Onboarding
    final prefs = await SharedPreferences.getInstance();
    final seenOnboarding = prefs.getBool('seen_onboarding') ?? false;

    if (!seenOnboarding) {
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const OnboardingScreen()),
        );
      }
      return;
    }

    // 2. Check Auth
    final token = await Api.getToken();
    if (token == null) {
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const AuthScreen()),
        );
      }
    } else {
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const HomeScreen()),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
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
      } else if (res.statusCode == 401) {
        // Token expired
        await Api.setToken(""); // Clear
        if (mounted) {
           Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => const AuthScreen()),
          );
        }
        return;
      }
    } catch (e) {
      // Network error
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
        _isLoading = true; 
      });
      _checkAccess();
    }
  }

  void _logout() async {
    await Api.setToken(""); // Clear token
    if (mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const AuthScreen()),
      );
    }
  }

  void _openProfile() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const ProfileScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (_hasAccess) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('TheorieZone'),
          actions: [
            IconButton(icon: const Icon(Icons.person), onPressed: _openProfile)
          ],
        ),
        body: const ExamListScreen(), // Embed list directly
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('TheorieZone'),
        actions: [
            IconButton(icon: const Icon(Icons.logout), onPressed: _logout)
        ],
      ),
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
