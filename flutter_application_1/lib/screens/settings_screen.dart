import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: Stack(
        children: <Widget>[
          ListView(
            padding: EdgeInsets.all(16.0),
            children: <Widget>[
              ListTile(
                title: Text('Security'),
                onTap: () {
                  Navigator.pushNamed(context, '/pin');
                },
              ),
              // Add more settings options here
            ],
          ),
          Positioned(
            left: 16.0,
            right: 16.0,
            bottom: 16.0,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor:  Colors.red,
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
              ),
              onPressed: () {
                Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
              },
              child: Text(
                'Logout',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
