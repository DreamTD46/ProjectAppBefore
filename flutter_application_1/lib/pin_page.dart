import 'package:flutter/material.dart';

class PinPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Please enter your PIN"),
            TextField(
              obscureText: true,
              keyboardType: TextInputType.number,
              maxLength: 6,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                counterText: '',
              ),
            ),
            ElevatedButton(
              onPressed: () {
                // Add your PIN verification logic here
              },
              child: Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}
