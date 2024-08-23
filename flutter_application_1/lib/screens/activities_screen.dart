import 'package:flutter/material.dart';
import 'new_activity_screen.dart';

class ActivitiesScreen extends StatefulWidget {
  @override
  _ActivitiesScreenState createState() => _ActivitiesScreenState();
}

class _ActivitiesScreenState extends State<ActivitiesScreen> {
  final List<Map<String, Object>> _activities = [
    {
      'title': 'Working',
      'description': 'Doing things, doing homework, building applications. Deadline: 8:00 a.m. 2019/7/20',
      'date': DateTime(2019, 7, 20),
    },
    // Add more initial activities here if needed
  ];

  void _addActivity(String title, String description, DateTime date) {
    setState(() {
      _activities.add({
        'title': title,
        'description': description,
        'date': date,
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Activities'),
      ),
      body: ListView.builder(
        itemCount: _activities.length,
        itemBuilder: (context, index) {
          final activity = _activities[index];
          return ListTile(
            title: Text(activity['title'] as String),
            subtitle: Text(
              '${activity['description']}\nDeadline: ${activity['date']}',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => NewActivityScreen(
                onAdd: _addActivity,
              ),
            ),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
