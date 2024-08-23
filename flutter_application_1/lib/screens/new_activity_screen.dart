import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class NewActivityScreen extends StatefulWidget {
  final void Function(String name, String note, DateTime dateTime) onAdd;

  NewActivityScreen({required this.onAdd});

  @override
  _NewActivityScreenState createState() => _NewActivityScreenState();
}

class _NewActivityScreenState extends State<NewActivityScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  DateTime _selectedDate = DateTime.now();

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
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Activity Name'),
            ),
            TextField(
              controller: _noteController,
              decoration: InputDecoration(labelText: 'Note'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final DateTime? picked = await showDatePicker(
                  context: context,
                  initialDate: _selectedDate,
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2100),
                );
                if (picked != null) {
                  setState(() {
                    _selectedDate = picked;
                  });
                }
              },
              child: Text('Select Date'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                saveActivity(); // Save the activity to the database
              },
              child: Text('Add Activity'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> saveActivity() async {
    String activityName = _nameController.text.trim();
    String description = _noteController.text.trim();
    String activityDate = _selectedDate.toIso8601String();

    if (activityName.isEmpty || description.isEmpty || activityDate.isEmpty) {
      Fluttertoast.showToast(
        msg: 'Please fill in all required fields!',
        backgroundColor: Colors.orange,
        textColor: Colors.white,
        toastLength: Toast.LENGTH_SHORT,
      );
      return;
    }

    try {
      var url = Uri.http("10.10.11.211", '/flutter/add_activity.php'); // Correct URL
      var response = await http.post(url, body: {
        "name": activityName,
        "note": description,
        "dateTime": activityDate,
      });

      var data = json.decode(response.body);

      if (data['status'] == "success") {
        Fluttertoast.showToast(
          msg: 'Activity Saved Successfully',
          backgroundColor: Colors.green,
          textColor: Colors.white,
          toastLength: Toast.LENGTH_SHORT,
        );
        widget.onAdd(activityName, description, _selectedDate); // Call the callback function
        Navigator.pop(context); // Go back to the previous screen
      } else {
        Fluttertoast.showToast(
          backgroundColor: Colors.red,
          textColor: Colors.white,
          msg: 'Failed to save activity: ${data['message']}',
          toastLength: Toast.LENGTH_SHORT,
        );
      }
    } catch (e) {
      Fluttertoast.showToast(
        backgroundColor: Colors.red,
        textColor: Colors.white,
        msg: 'An error occurred. Please try again.',
        toastLength: Toast.LENGTH_SHORT,
      );
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _noteController.dispose();
    super.dispose();
  }
}
