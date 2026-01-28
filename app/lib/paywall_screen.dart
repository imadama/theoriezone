import 'package:flutter/material.dart';
import 'package:theoriezone_app/api.dart';

class PaywallScreen extends StatefulWidget {
  const PaywallScreen({super.key});

  @override
  State<PaywallScreen> createState() => _PaywallScreenState();
}

class _PaywallScreenState extends State<PaywallScreen> {
  bool _isLoading = false;

  Future<void> _buyAccess() async {
    setState(() => _isLoading = true);
    
    // TODO: Integreer hier echte In-App Purchase logic (revenue_cat of in_app_purchase)
    // Voor MVP simuleren we een succesvolle aankoop via de backend
    
    try {
      final response = await Api.post('/entitlements/grant-demo', {
        'product_id': 'com.theoriezone.car.90days'
      });

      if (response.statusCode == 200) {
        if (mounted) {
          Navigator.of(context).pop(true); // Return true = success
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Fout bij aankoop: ${response.body}')),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Netwerkfout: $e')),
        );
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Toegang Kopen')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Icon(Icons.lock_outline, size: 80, color: Colors.deepPurple),
            const SizedBox(height: 24),
            const Text(
              'Ontgrendel alle theorie',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            const Text(
              'Krijg 90 dagen onbeperkt toegang tot alle hoofdstukken en examens.',
              style: TextStyle(fontSize: 16, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: _isLoading ? null : _buyAccess,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: _isLoading 
                ? const CircularProgressIndicator(color: Colors.white)
                : const Text('Koop toegang voor €29,99'),
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: () {
                // Restore purchases logic
              },
              child: const Text('Aankopen herstellen'),
            ),
          ],
        ),
      ),
    );
  }
}
