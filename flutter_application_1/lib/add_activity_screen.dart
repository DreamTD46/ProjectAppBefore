import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

class AddActivityScreen extends StatefulWidget {
  @override
  _AddActivityScreenState createState() => _AddActivityScreenState();
}

class _AddActivityScreenState extends State<AddActivityScreen> {
  TextEditingController activityNameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController activityDateController = TextEditingController();

  Future<void> saveActivity() async {
    String activityName = activityNameController.text.trim();
    String description = descriptionController.text.trim();
    String activityDate = activityDateController.text.trim();

    if (activityName.isEmpty || activityDate.isEmpty) {
      Fluttertoast.showToast(
        msg: 'Please fill in all required fields!',
        backgroundColor: Colors.orange,
        textColor: Colors.white,
        toastLength: Toast.LENGTH_SHORT,
      );
      return;
    }

    try {
      var url = Uri.http("10.10.11.238", '/flutter/fetch.php');
      var response = await http.post(url, body: {
        "name": activityName,
        "note": description,
        "dateTime": activityDate,
      });

      var data = json.decode(response.body);

      if (data.toString() == "Success") {
        Fluttertoast.showToast(
          msg: 'Activity Saved Successfully',
          backgroundColor: Colors.green,
          textColor: Colors.white,
          toastLength: Toast.LENGTH_SHORT,
        );
        Navigator.pop(context); // Go back to the previous screen
      } else {
        Fluttertoast.showToast(
          backgroundColor: Colors.red,
          textColor: Colors.white,
          msg: 'Failed to save activity: $data',
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('New Activity'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            // TextField for Activity Name
            TextField(
              controller: activityNameController,
              style: const TextStyle(color: Colors.black),
              decoration: InputDecoration(
                hintText: 'Activity Name',
                hintStyle: const TextStyle(
                  fontSize: 16,
                  color: Colors.black54,
                  fontWeight: FontWeight.bold,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: const BorderSide(
                    width: 0,
                    style: BorderStyle.none,
                  ),
                ),
                filled: true,
                fillColor: Colors.white,
                contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
              ),
            ),
            SizedBox(height: 16),

            // TextField for Description
            TextField(
              controller: descriptionController,
              style: const TextStyle(color: Colors.black),
              decoration: InputDecoration(
                hintText: 'Note',
                hintStyle: const TextStyle(
                  fontSize: 16,
                  color: Colors.black54,
                  fontWeight: FontWeight.bold,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: const BorderSide(
                    width: 0,
                    style: BorderStyle.none,
                  ),
                ),
                filled: true,
                fillColor: Colors.white,
                contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
              ),
            ),
            SizedBox(height: 16),

            // TextField for Activity Date
            TextField(
              controller: activityDateController,
              style: const TextStyle(color: Colors.black),
              decoration: InputDecoration(
                hintText: 'Date & Time',
                hintStyle: const TextStyle(
                  fontSize: 16,
                  color: Colors.black54,
                  fontWeight: FontWeight.bold,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: const BorderSide(
                    width: 0,
                    style: BorderStyle.none,
                  ),
                ),
                filled: true,
                fillColor: Colors.white,
                contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: saveActivity,
              child: Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
