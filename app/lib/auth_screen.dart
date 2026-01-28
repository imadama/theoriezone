import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:theoriezone_app/api.dart';
import 'package:theoriezone_app/main.dart'; // To navigate to HomeScreen

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool _isLogin = true; // Toggle between Login and Register
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();

  // Fields
  String _email = '';
  String _password = '';
  String _name = '';

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();

    setState(() => _isLoading = true);

    try {
      final endpoint = _isLogin ? '/login' : '/register';
      final body = {
        'email': _email,
        'password': _password,
        if (!_isLogin) 'name': _name,
      };

      final response = await Api.post(endpoint, body);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final token = data['access_token'];
        
        await Api.setToken(token);

        if (mounted) {
          // Navigate to Home/Entitlement Check
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => const HomeScreen()),
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Fout: ${response.body}')),
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
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.school, size: 80, color: Colors.deepPurple),
                const SizedBox(height: 24),
                Text(
                  _isLogin ? 'Inloggen' : 'Account aanmaken',
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 24),
                
                if (!_isLogin)
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Naam', border: OutlineInputBorder()),
                    validator: (v) => v!.isEmpty ? 'Vul een naam in' : null,
                    onSaved: (v) => _name = v!,
                  ),
                if (!_isLogin) const SizedBox(height: 16),

                TextFormField(
                  decoration: const InputDecoration(labelText: 'Email', border: OutlineInputBorder()),
                  keyboardType: TextInputType.emailAddress,
                  validator: (v) => !v!.contains('@') ? 'Geldig email adres vereist' : null,
                  onSaved: (v) => _email = v!,
                ),
                const SizedBox(height: 16),
                
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Wachtwoord', border: OutlineInputBorder()),
                  obscureText: true,
                  validator: (v) => v!.length < 6 ? 'Minimaal 6 tekens' : null,
                  onSaved: (v) => _password = v!,
                ),
                const SizedBox(height: 24),

                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _submit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                      foregroundColor: Colors.white,
                    ),
                    child: _isLoading 
                      ? const CircularProgressIndicator(color: Colors.white)
                      : Text(_isLogin ? 'Inloggen' : 'Registreren'),
                  ),
                ),
                const SizedBox(height: 16),
                
                TextButton(
                  onPressed: () => setState(() => _isLogin = !_isLogin),
                  child: Text(_isLogin 
                    ? 'Nog geen account? Registreer hier' 
                    : 'Al een account? Log in'),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
