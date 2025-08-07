import 'package:flutter/material.dart';
import '../db/database_helper.dart';
import '../models/user_model.dart';

class RegisterPage extends StatefulWidget {
  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  void _register() async {
    if (_formKey.currentState!.validate()) {
      final user = User(
        name: _nameCtrl.text.trim(),
        email: _emailCtrl.text.trim(),
        password: _passCtrl.text.trim(),
      );

      try {
        await DatabaseHelper().registerUser(user);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Register successful')),
        );
        Navigator.pushReplacementNamed(context, '/login');
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Email has been registered')),
        );
      }
    }
  }

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
                onPressed: _register,
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
