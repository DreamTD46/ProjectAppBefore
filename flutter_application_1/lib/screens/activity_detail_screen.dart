import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
<<<<<<< HEAD
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
=======
import 'package:intl/intl.dart';  // Add this import for date and time formatting
>>>>>>> 397857386c3cabe38132a674b264d33e15ce71c3

class ActivityDetailScreen extends StatefulWidget {
  final Map<String, dynamic> activity;
  final int index;
  final Function(String, String, DateTime, int?) onSave;
  final Function(int) onDelete;

  ActivityDetailScreen({
    required this.activity,
    required this.index,
    required this.onSave,
    required this.onDelete,
  });

  @override
  _ActivityDetailScreenState createState() => _ActivityDetailScreenState();
}

class _ActivityDetailScreenState extends State<ActivityDetailScreen> {
  late TextEditingController _nameController;
  late TextEditingController _noteController;
  late DateTime _dateTime;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.activity['name']);
    _noteController = TextEditingController(text: widget.activity['note']);
    _dateTime =
        DateTime.parse('${widget.activity['date']} ${widget.activity['time']}');
  }

  Future<void> _selectDate() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _dateTime,
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
    if (pickedDate != null && pickedDate != _dateTime) {
      setState(() {
        _dateTime = DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
          _dateTime.hour,
          _dateTime.minute,
        );
      });
    }
  }

  Future<void> _selectTime() async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_dateTime),
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
        _dateTime = DateTime(
          _dateTime.year,
          _dateTime.month,
          _dateTime.day,
          pickedTime.hour,
          pickedTime.minute,
        );
      });
    }
  }

<<<<<<< HEAD
  Future<void> _saveActivity() async {
    final String formattedDate = DateFormat('yyyy-MM-dd').format(_dateTime);
    final String formattedTime = DateFormat('HH:mm:ss').format(_dateTime);
    final bool isEditing =
        widget.activity['id'] != null && widget.activity['id'] != '';

    try {
      final response = await http.post(
        Uri.parse(isEditing
            ? 'http://192.168.1.35/flutter/edit_activity.php'
            : 'http://192.168.1.35/flutter/add_activity.php'),
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: {
          'id': isEditing ? widget.activity['id'] : '',
          'activity_name': _nameController.text,
          'description': _noteController.text,
          'activity_date': formattedDate,
          'activity_time': formattedTime,
        },
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        Fluttertoast.showToast(
          msg: responseData['message'],
          toastLength: Toast.LENGTH_SHORT,
        );
        widget.onSave(
          _nameController.text,
          _noteController.text,
          _dateTime,
          widget.index,
        );
        Navigator.pop(context);
      } else {
        Fluttertoast.showToast(
          msg: 'Error: ${response.reasonPhrase}',
          toastLength: Toast.LENGTH_SHORT,
        );
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: 'Error saving activity: $e',
        toastLength: Toast.LENGTH_SHORT,
      );
    }
  }

  Widget _buildElevatedButton({
    required String label,
    required VoidCallback onPressed,
    Color? backgroundColor,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Text(label),
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: backgroundColor ?? Colors.teal,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        shadowColor: Colors.black45,
        elevation: 5,
      ),
    );
  }

=======
>>>>>>> 397857386c3cabe38132a674b264d33e15ce71c3
  @override
  Widget build(BuildContext context) {
    final DateFormat dateFormat = DateFormat('dd-MM-yyyy');
    final DateFormat timeFormat = DateFormat('HH:mm');

    return Scaffold(
      appBar: AppBar(
        title: Text('Activity Details'),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Name',
<<<<<<< HEAD
                labelStyle: TextStyle(
                  color: Colors.teal,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
=======
                labelStyle: TextStyle(color: Colors.teal, fontSize: 16, fontWeight: FontWeight.w600),
>>>>>>> 397857386c3cabe38132a674b264d33e15ce71c3
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.teal),
                ),
              ),
            ),
            TextField(
              controller: _noteController,
              decoration: InputDecoration(
                labelText: 'Note',
<<<<<<< HEAD
                labelStyle: TextStyle(
                  color: Colors.teal,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
=======
                labelStyle: TextStyle(color: Colors.teal, fontSize: 16, fontWeight: FontWeight.w600),
>>>>>>> 397857386c3cabe38132a674b264d33e15ce71c3
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.teal),
                ),
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "${dateFormat.format(_dateTime)} ${timeFormat.format(_dateTime)}",
<<<<<<< HEAD
                  style: TextStyle(
                    color: Colors.teal,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(width: 10),
                _buildElevatedButton(
                  label: 'Select Date',
                  onPressed: _selectDate,
                ),
                SizedBox(width: 10),
                _buildElevatedButton(
                  label: 'Select Time',
                  onPressed: _selectTime,
=======
                  style: TextStyle(color: Colors.teal, fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(width: 10),
                ElevatedButton.icon(
                  onPressed: _selectDate,
                  icon: Icon(Icons.calendar_today),
                  label: Text('Select Date'),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white, backgroundColor: Colors.teal,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                    shadowColor: Colors.black45,
                    elevation: 5,
                  ),
                ),
                SizedBox(width: 10),
                ElevatedButton.icon(
                  onPressed: _selectTime,
                  icon: Icon(Icons.access_time),
                  label: Text('Select Time'),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white, backgroundColor: Colors.teal,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                    shadowColor: Colors.black45,
                    elevation: 5,
                  ),
>>>>>>> 397857386c3cabe38132a674b264d33e15ce71c3
                ),
              ],
            ),
            SizedBox(height: 20),
<<<<<<< HEAD
            _buildElevatedButton(
              label:
                  widget.activity['id'] != '' ? 'Save Changes' : 'Add Activity',
              onPressed: _saveActivity,
            ),
            SizedBox(height: 20),
            if (widget.activity['id'] != null && widget.activity['id'] != '')
              _buildElevatedButton(
                label: 'Delete',
                onPressed: () {
                  widget.onDelete(widget.index);
                  Navigator.pop(context);
                },
                backgroundColor: Colors.red,
=======
            ElevatedButton(
              onPressed: () {
                widget.onSave(
                  _nameController.text,
                  _noteController.text,
                  _dateTime,
                  widget.index,
                );
                Navigator.pop(context);
              },
              child: Text('Save'),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white, backgroundColor: Colors.teal,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                shadowColor: Colors.black45,
                elevation: 5,
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                widget.onDelete(widget.index);
                Navigator.pop(context);
              },
              child: Text('Delete'),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white, backgroundColor: Colors.red,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                shadowColor: Colors.black45,
                elevation: 5,
>>>>>>> 397857386c3cabe38132a674b264d33e15ce71c3
              ),
          ],
        ),
      ),
    );
  }
}
