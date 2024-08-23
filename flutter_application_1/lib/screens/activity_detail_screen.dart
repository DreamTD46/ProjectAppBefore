import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ActivityDetailScreen extends StatefulWidget {
  final Map<String, dynamic> activity;
  final int index;
  final Function(String, String, DateTime, int?) onSave;
  final Function(int) onDelete;

  ActivityDetailScreen({required this.activity, required this.index, required this.onSave, required this.onDelete});

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
    _dateTime = DateTime.parse(widget.activity['dateTime']);
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _dateTime,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != _dateTime) {
      setState(() {
        _dateTime = DateTime(
          picked.year,
          picked.month,
          picked.day,
          _dateTime.hour,
          _dateTime.minute,
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Activity Details')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: _noteController,
              decoration: InputDecoration(labelText: 'Note'),
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Text(
                  "${_dateTime.toLocal()}".split(' ')[0] +
                      " " +
                      _dateTime.hour.toString().padLeft(2, '0') +
                      ":" +
                      _dateTime.minute.toString().padLeft(2, '0'),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: _selectDate,
                  child: Text('Select Date'),
                ),
              ],
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                widget.onSave(
                  _nameController.text,
                  _noteController.text,
                  _dateTime,
                  widget.index, // Include index for updates
                );
                Navigator.pop(context);
              },
              child: Text('Save'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                widget.onDelete(widget.index);
                Navigator.pop(context);
              },
              child: Text('Delete'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
