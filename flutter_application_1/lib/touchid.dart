import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: PinInputScreen(),
    );
  }
}

class PinInputScreen extends StatefulWidget {
  @override
  _PinInputScreenState createState() => _PinInputScreenState();
}

class _PinInputScreenState extends State<PinInputScreen> {
  final List<String> _pin = ['', '', '', '', '', ''];
  int _pinIndex = 0;

  void _handleKeypadTap(String value) {
    setState(() {
      if (value == 'X') {
        if (_pinIndex > 0) {
          _pinIndex--;
          _pin[_pinIndex] = '';
        }
      } else {
        if (_pinIndex < 6) {
          _pin[_pinIndex] = value;
          _pinIndex++;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Enter PIN'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Please enter your PIN', style: TextStyle(fontSize: 24)),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: _pin.map((e) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: CircleAvatar(
                    radius: 10,
                    backgroundColor: Colors.black,
                    child: e.isEmpty
                        ? Container()
                        : CircleAvatar(
                            radius: 5,
                            backgroundColor: Colors.white,
                          ),
                  ),
                );
              }).toList(),
            ),
            SizedBox(height: 40),
            // Add Touch ID widget here
            Container(
              padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10.0,
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.fingerprint, size: 50, color: Colors.red),
                  SizedBox(height: 10),
                  Text(
                    'Touch ID',
                    style: TextStyle(fontSize: 18),
                  ),
                  SizedBox(height: 5),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      // Handle Touch ID action here
                    },
                    child: Text('Action'),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: GridView.builder(
                itemCount: 12,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                ),
                itemBuilder: (context, index) {
                  String value = '';
                  if (index < 9) {
                    value = '${index + 1}';
                  } else if (index == 9) {
                    value = '';
                  } else if (index == 10) {
                    value = '0';
                  } else if (index == 11) {
                    value = 'X';
                  }
                  return GestureDetector(
                    onTap: () => _handleKeypadTap(value),
                    child: Container(
                      margin: const EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.grey.shade300,
                      ),
                      child: Center(
                        child: Text(
                          value,
                          style: TextStyle(fontSize: 24),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
