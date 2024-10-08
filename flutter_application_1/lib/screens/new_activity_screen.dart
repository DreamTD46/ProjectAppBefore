import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart'; // For date-time formatting

class NewActivityScreen extends StatefulWidget {
  final void Function(String name, String note, DateTime dateTime) onAdd;

  NewActivityScreen({required this.onAdd});

  @override
  _NewActivityScreenState createState() => _NewActivityScreenState();
}

class _NewActivityScreenState extends State<NewActivityScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  DateTime _selectedDateTime = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('New Activity'),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _buildTextField(_nameController, 'Activity Name'),
            SizedBox(height: 20),
            _buildTextField(_noteController, 'Note'),
            SizedBox(height: 20),
            _buildDateTimePickerButtons(),
            SizedBox(height: 20),
            _buildAddActivityButton(),
          ],
        ),
      ),
    );
  }

  TextField _buildTextField(TextEditingController controller, String label) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(
            color: Colors.teal, fontSize: 16, fontWeight: FontWeight.w600),
        border: OutlineInputBorder(),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.teal),
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
    );
  }

  Column _buildDateTimePickerButtons() {
    return Column(
      children: [
        ElevatedButton.icon(
          onPressed: _selectDate,
          icon: Icon(Icons.calendar_today),
          label: Text('Select Date'),
          style: _buttonStyle(),
        ),
        SizedBox(height: 20),
        ElevatedButton.icon(
          onPressed: _selectTime,
          icon: Icon(Icons.access_time),
          label: Text('Select Time'),
          style: _buttonStyle(),
        ),
      ],
    );
  }

  ElevatedButton _buildAddActivityButton() {
    return ElevatedButton(
      onPressed: saveActivity,
      child: Text('Add Activity'),
      style: _buttonStyle(),
    );
  }

  ButtonStyle _buttonStyle() {
    return ElevatedButton.styleFrom(
      foregroundColor: Colors.white,
      backgroundColor: Colors.teal,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      shadowColor: Colors.black45,
      elevation: 5,
    );
  }

  Future<void> _selectDate() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDateTime,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: Colors.teal,
            hintColor: Colors.teal,
            buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.primary),
            colorScheme: ColorScheme.light(primary: Colors.teal),
          ),
          child: child!,
        );
      },
    );
    if (pickedDate != null && pickedDate != _selectedDateTime) {
      setState(() {
        _selectedDateTime = DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
          _selectedDateTime.hour,
          _selectedDateTime.minute,
        );
      });
    }
  }

  Future<void> _selectTime() async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_selectedDateTime),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: Colors.teal,
            hintColor: Colors.teal,
            buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.primary),
            colorScheme: ColorScheme.light(primary: Colors.teal),
          ),
          child: child!,
        );
      },
    );
    if (pickedTime != null) {
      setState(() {
        _selectedDateTime = DateTime(
          _selectedDateTime.year,
          _selectedDateTime.month,
          _selectedDateTime.day,
          pickedTime.hour,
          pickedTime.minute,
        );
      });
    }
  }

  Future<void> saveActivity() async {
    String activityName = _nameController.text.trim();
    String description = _noteController.text.trim();

    // Split DateTime into date and time
    String activityDate = DateFormat('yyyy-MM-dd').format(_selectedDateTime);
    String activityTime = DateFormat('HH:mm:ss').format(_selectedDateTime);

    if (activityName.isEmpty || description.isEmpty) {
      Fluttertoast.showToast(
        msg: 'Please fill in all required fields!',
        backgroundColor: Colors.orange,
        textColor: Colors.white,
        toastLength: Toast.LENGTH_SHORT,
      );
      return;
    }

    try {
      var url = Uri.parse("http://192.168.1.35/flutter/add_activity.php");
      var response = await http.post(url, body: {
        "name": activityName,
        "note": description,
        "activity_date": activityDate,
        "activity_time": activityTime,
      });

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        if (data['status'] == "success") {
          Fluttertoast.showToast(
            msg: 'Activity Saved Successfully',
            backgroundColor: Colors.green,
            textColor: Colors.white,
            toastLength: Toast.LENGTH_SHORT,
          );
          widget.onAdd(activityName, description, _selectedDateTime);
          Navigator.pop(context);
        } else {
          Fluttertoast.showToast(
            backgroundColor: Colors.red,
            textColor: Colors.white,
            msg: 'Failed to save activity: ${data['message']}',
            toastLength: Toast.LENGTH_SHORT,
          );
        }
      } else {
        Fluttertoast.showToast(
          backgroundColor: Colors.red,
          textColor: Colors.white,
          msg: 'Failed to save activity. Status code: ${response.statusCode}',
          toastLength: Toast.LENGTH_SHORT,
        );
      }
    } catch (e) {
      Fluttertoast.showToast(
        backgroundColor: Colors.red,
        textColor: Colors.white,
        msg: 'An error occurred: $e',
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
