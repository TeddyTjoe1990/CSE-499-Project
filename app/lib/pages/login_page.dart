import 'package:flutter/material.dart';
import '../db/database_helper.dart';

class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  void _login() async {
    if (_formKey.currentState!.validate()) {
      final user = await DatabaseHelper().getUser(_emailCtrl.text.trim(), _passCtrl.text.trim());

      if (!mounted) return;

      if (user != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Welcome, ${user.name}')),
        );
        Navigator.pushReplacementNamed(context, '/home');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Incorrect email or password')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _emailCtrl,
                decoration: InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
                validator: (val) => val == null || !val.contains('@') ? 'Invalid email' : null,
              ),
              TextFormField(
                controller: _passCtrl,
                decoration: InputDecoration(labelText: 'Password'),
                obscureText: true,
                validator: (val) => val == null || val.length < 6 ? 'Minimum 6 characters' : null,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _login,
                child: Text('Login'),
              ),
              TextButton(
                onPressed: () => Navigator.pushReplacementNamed(context, '/register'),
                child: Text("Don't have an account? Register"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
