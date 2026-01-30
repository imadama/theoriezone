import 'package:flutter/material.dart';
import 'package:theoriezone_app/exam_selection_screen.dart';
import 'package:theoriezone_app/theme.dart';
import 'package:theoriezone_app/api.dart';
import 'dart:convert';

class DashboardScreen extends StatefulWidget {
  final Map<String, dynamic>? user;
  const DashboardScreen({super.key, this.user});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  // Stats could be fetched here
  int _examsPassed = 0;
  int _examsTotal = 0;

  @override
  void initState() {
    super.initState();
    _fetchStats();
  }

  Future<void> _fetchStats() async {
    try {
      final res = await Api.get('/attempts');
      if (res.statusCode == 200) {
        final List list = jsonDecode(res.body);
        if (mounted) {
          setState(() {
            _examsTotal = list.length;
            _examsPassed = list.where((a) => a['passed'] == true).length;
          });
        }
      }
    } catch(e) {}
  }

  @override
  Widget build(BuildContext context) {
    final userName = widget.user?['name']?.split(' ')[0] ?? 'Leerling';

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Hoi $userName! 👋',
                    style: const TextStyle(
                      fontSize: 26, 
                      fontWeight: FontWeight.w800, 
                      color: AppColors.textDark
                    ),
                  ),
                  const Text(
                    'Klaar om te slagen?',
                    style: TextStyle(color: AppColors.textLight, fontSize: 16),
                  ),
                ],
              ),
              // Could put profile pic here
            ],
          ),
          const SizedBox(height: 24),

          // Progress Card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF2563EB), Color(0xFF60A5FA)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(color: Colors.blue.withOpacity(0.3), blurRadius: 20, offset: const Offset(0, 10))
              ]
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Je voortgang",
                        style: TextStyle(color: Colors.white70, fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "$_examsPassed / $_examsTotal geslaagd",
                        style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        "Blijf oefenen om je kans van slagen te verhogen!",
                        style: TextStyle(color: Colors.white, fontSize: 13, height: 1.4),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.show_chart, color: Colors.white, size: 32),
                )
              ],
            ),
          ),
          const SizedBox(height: 32),

import 'package:theoriezone_app/lessons_screen.dart';

// ... inside _DashboardScreenState build ...

          // Quick Actions
          const Text(
            "Oefenen",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textDark),
          ),
          const SizedBox(height: 16),

          Row(
            children: [
              Expanded(
                child: _ActionCard(
                  title: "Start Examen",
                  subtitle: "50 Vragen",
                  icon: Icons.play_arrow_rounded,
                  color: AppColors.primary,
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ExamSelectionScreen())),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _ActionCard(
                  title: "Rijlessen",
                  subtitle: "Mijn Agenda",
                  icon: Icons.calendar_month_rounded,
                  color: Colors.purple,
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const LessonsScreen())),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 24),

import 'package:theoriezone_app/progress_screen.dart';

// ...

          // Secondary Row
          Row(
            children: [
              Expanded(
                 child: _ActionCard(
                  title: "Voortgang",
                  subtitle: "Mijn Skills",
                  icon: Icons.bar_chart_rounded,
                  color: Colors.green,
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ProgressScreen())),
                ),
              ),
               const SizedBox(width: 16),
               Expanded(
                 child: _ActionCard(
                  title: "Fouten",
                  subtitle: "Reviewen",
                  icon: Icons.refresh_rounded,
                  color: Colors.orange,
                  onTap: () {
                     // Navigate to Profile/History to review mistakes
                     ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Ga naar je profiel om fouten te zien.")));
                  },
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 24),
          // Categories List (Horizontal) or Tips
          // ...
        ],
      ),
    );
  }
}

class _ActionCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _ActionCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.grey.shade100),
          boxShadow: [
             BoxShadow(color: Colors.grey.shade100, blurRadius: 10, offset: const Offset(0, 4))
          ]
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(height: 16),
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 4),
            Text(subtitle, style: const TextStyle(color: AppColors.textLight, fontSize: 12)),
          ],
        ),
      ),
    );
  }
}
