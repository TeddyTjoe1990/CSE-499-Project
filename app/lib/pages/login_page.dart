import 'package:flutter/material.dart';
import '../db/database_helper.dart';
//import '../models/user_model.dart';

class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();

  void _login() async {
    if (_formKey.currentState!.validate()) {
      final user = await DatabaseHelper().getUser(_emailCtrl.text, _passCtrl.text);
      
      if (!mounted) return; 

      if (user != null) {
        //Navigate to the home page if login succeed
        Navigator.pushReplacementNamed(context, '/home');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Welcome, ${user.name}')),
        );
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
                validator: (val) => val == null || !val.contains('@') ? 'Email tidak valid' : null,
              ),
              TextFormField(
                controller: _passCtrl,
                decoration: InputDecoration(labelText: 'Password'),
                obscureText: true,
                validator: (val) => val == null || val.length < 6 ? 'Minimal 6 karakter' : null,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _login,
                child: Text('Login'),
              ),
              TextButton(
                onPressed: () => Navigator.pushReplacementNamed(context, '/register'),
                child: Text('Belum punya akun? Daftar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
