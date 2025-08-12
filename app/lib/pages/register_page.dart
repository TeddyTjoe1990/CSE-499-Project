import 'package:flutter/material.dart';
import '../db/database_helper.dart';
import '../models/user_model.dart';

class RegisterPage extends StatelessWidget {

  // Form
  final _formKey = GlobalKey<FormState>();

  // Name, Email and Password State
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();

  // Code for register
  void _register(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      final user = User(
        name: _nameCtrl.text,
        email: _emailCtrl.text,
        password: _passCtrl.text,
      );

      try {
        await DatabaseHelper().registerUser(user);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Register successful')));
        Navigator.pushReplacementNamed(context, '/login');
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Email has been registered')));
      }
    }
  }

  // Register Page Scaffold
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Register')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nameCtrl,
                decoration: InputDecoration(labelText: 'Name'),
                validator: (val) => val == null || val.isEmpty ? 'Name required' : null,
              ),
              TextFormField(
                controller: _emailCtrl,
                decoration: InputDecoration(labelText: 'Email'),
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
                onPressed: () => _register(context),
                child: Text('Register'),
              ),
              TextButton(
                onPressed: () => Navigator.pushReplacementNamed(context, '/login'),
                child: Text('Already have an account? Log in'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
