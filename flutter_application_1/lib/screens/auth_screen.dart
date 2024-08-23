import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';

class AuthScreen extends StatelessWidget {
  final LocalAuthentication auth = LocalAuthentication();

  Future<void> _authenticate(BuildContext context) async {
    bool authenticated = false;
    try {
      authenticated = await auth.authenticate(
        localizedReason: 'Authenticate to access the app',
        options: const AuthenticationOptions(
          useErrorDialogs: true,
          stickyAuth: true,
        ),
      );
    } catch (e) {
      print(e);
    }

    if (authenticated) {
      // Authentication successful
      Navigator.pushReplacementNamed(context, '/activities');
    } else {
      // Authentication failed
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () => _authenticate(context),
          child: Text('Authenticate'),
        ),
      ),
    );
  }
}

