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
      appBar: AppBar(
        title: Text('Welcome!'),
        backgroundColor: Colors.teal, // ใช้สีหลัก
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                labelStyle: TextStyle(color: Colors.teal), // สีของป้ายชื่อ
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.teal), // สีขอบขณะเลือก
                ),
              ),
            ),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(
                labelText: 'Password',
                labelStyle: TextStyle(color: Colors.teal), // สีของป้ายชื่อ
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.teal), // สีขอบขณะเลือก
                ),
              ),
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
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white, backgroundColor: Colors.teal, // สีของข้อความ
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/pin');
              },
              child: Text('Forgot password'),
              style: TextButton.styleFrom(
                foregroundColor: Colors.teal, // สีของข้อความปุ่ม
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/Register');
              },
              child: Text('Register'),
              style: TextButton.styleFrom(
                foregroundColor: Colors.teal, // สีของข้อความปุ่ม
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                await authService.signInWithGoogle();
                Navigator.pushReplacementNamed(context, '/Googlelogin');
              },
              child: Text('Google'),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white, backgroundColor: Colors.red, // สีของข้อความ
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                await authService.signInWithFacebook();
                Navigator.pushReplacementNamed(context, '/FacebookLogin');
              },
              child: Text('Facebook'),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white, backgroundColor: Colors.blue, // สีของข้อความ
              ),
            ),
          ],
        ),
      ),
    );
  }
}
