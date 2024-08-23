import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/mock_auth_service.dart';

class LoginScreen extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<MockAuthService>(context);
    return Scaffold(
      appBar: AppBar(title: Text('Welcome!')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                if (emailController.text.isEmpty || passwordController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Please fill in all fields')),
                  );
                } else {
                  await authService.signInWithEmail(
                    emailController.text,
                    passwordController.text,
                  );
                  Navigator.pushReplacementNamed(context, '/home');
                }
              },
              child: Text('Login'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/pin');
              },
              child: Text('Forgot password'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/Register');
              },
              child: Text('Register'),
            ),
            ElevatedButton(
              onPressed: () async {
                await authService.signInWithGoogle();
                Navigator.pushReplacementNamed(context, '/Googlelogin');
              },
              child: Text('Google'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            ),
            ElevatedButton(
              onPressed: () async {
                await authService.signInWithFacebook();
                Navigator.pushReplacementNamed(context, '/FacebookLogin');
              },
              child: Text('Facebook'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
            ),
          ],
        ),
      ),
    );
  }
}