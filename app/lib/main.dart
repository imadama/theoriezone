import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:theoriezone_app/paywall_screen.dart';
import 'package:theoriezone_app/api.dart';
import 'package:theoriezone_app/dashboard_screen.dart';
import 'package:theoriezone_app/auth_screen.dart';
import 'package:theoriezone_app/profile_screen.dart';
import 'package:theoriezone_app/onboarding_screen.dart';
import 'package:theoriezone_app/theme.dart';
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
      theme: AppTheme.lightTheme,
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
  Map<String, dynamic>? _user;

  @override
  void initState() {
    super.initState();
    _checkAccess();
    _fetchUser();
  }

  Future<void> _fetchUser() async {
     try {
       final res = await Api.get('/user');
       if (res.statusCode == 200) {
         if (mounted) setState(() => _user = jsonDecode(res.body));
       }
     } catch(e) {}
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
        await Api.setToken(""); 
        if (mounted) {
           Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => const AuthScreen()),
          );
        }
        return;
      }
    } catch (e) {}
    
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
    await Api.setToken(""); 
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
          title: const Text('TheorieZone', style: TextStyle(color: Colors.transparent)), 
          elevation: 0,
          backgroundColor: AppColors.background, // Match dashboard bg
          actions: [
            Container(
               margin: const EdgeInsets.only(right: 16),
               decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
               child: IconButton(icon: const Icon(Icons.person, color: AppColors.primary), onPressed: _openProfile)
            )
          ],
        ),
        body: DashboardScreen(user: _user),
      );
    }

    // No Access State (keep simple for now, maybe redesign later)
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
            const Icon(Icons.school_outlined, size: 80, color: AppColors.primary),
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
              child: const Text('Cursus ontgrendelen'),
            ),
          ],
        ),
      ),
    );
  }
}
