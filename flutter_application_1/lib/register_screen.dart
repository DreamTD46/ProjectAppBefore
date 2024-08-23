import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  String? _accountName;
  String? _dob;
  String? _password;
  String? _pin;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register'),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Account Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your account name';
                  }
                  return null;
                },
                onSaved: (value) {
                  _accountName = value;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Date of Birth'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your date of birth';
                  }
                  return null;
                },
                onSaved: (value) {
                  _dob = value;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Password'),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }
                  return null;
                },
                onSaved: (value) {
                  _password = value;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'PIN (6 digits)'),
                obscureText: true,
                maxLength: 6,
                validator: (value) {
                  if (value == null || value.isEmpty || value.length != 6) {
                    return 'Please enter a 6-digit PIN';
                  }
                  return null;
                },
                onSaved: (value) {
                  _pin = value;
                },
              ),
              ElevatedButton(
                onPressed: _register,
                child: Text('Register'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _register() async {
    if (_formKey.currentState?.validate() == true) {
      _formKey.currentState?.save();
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('accountName', _accountName!);
      await prefs.setString('dob', _dob!);
      await prefs.setString('password', _password!);
      await prefs.setString('pin', _pin!);
      Navigator.pushReplacementNamed(context, '/login');
    }
  }
}
