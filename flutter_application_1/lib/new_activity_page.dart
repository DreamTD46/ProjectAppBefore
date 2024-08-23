import 'package:flutter/material.dart';

class NewActivityPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('New Activity'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: 'Name',
              ),
            ),
            TextField(
              decoration: InputDecoration(
                labelText: 'Note',
              ),
            ),
            TextField(
              decoration: InputDecoration(
                labelText: 'Date & Time',
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // เพิ่ม logic การบันทึกของคุณได้ที่นี่
              },
              child: Text('Done'),
            ),
          ],
        ),
      ),
    );
  }
}
