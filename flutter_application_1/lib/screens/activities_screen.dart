import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Import for date formatting
import 'new_activity_screen.dart';

class Activity {
  final String title;
  final String description;
  final DateTime date;

  Activity({
    required this.title,
    required this.description,
    required this.date,
  });
}

class ActivitiesScreen extends StatefulWidget {
  @override
  _ActivitiesScreenState createState() => _ActivitiesScreenState();
}

class _ActivitiesScreenState extends State<ActivitiesScreen> {
  final List<Activity> _activities = [
    Activity(
      title: 'Working',
      description:
          'Doing things, doing homework, building applications. Deadline: 8:00 a.m. 2019/7/20',
      date: DateTime(2019, 7, 20),
    ),
    // Add more initial activities here if needed
  ];

  void _addActivity(String title, String description, DateTime date) {
    setState(() {
      _activities
          .add(Activity(title: title, description: description, date: date));
    });
  }

  void _deleteActivity(int index) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Are you sure?'),
        content: Text('Do you want to delete this activity?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop(); // Close dialog
            },
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _activities.removeAt(index);
              });
              Navigator.of(ctx).pop(); // Close dialog
            },
            child: Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _showActivityDetails(Activity activity) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(activity.title),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Description: ${activity.description}'),
            SizedBox(height: 10),
            Text('Deadline: ${DateFormat('dd-MM-yyyy').format(activity.date)}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop(); // Close dialog
            },
            child: Text('Close'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Activities'),
        backgroundColor: Colors.teal, // Ensure theme consistency
      ),
      body: _activities.isEmpty
          ? Center(
              child: Text('No activities added yet!'),
            )
          : ListView.builder(
              itemCount: _activities.length,
              itemBuilder: (context, index) {
                final activity = _activities[index];
                return ListTile(
                  title: Text(activity.title),
                  subtitle: Text(
                    activity.description,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _deleteActivity(index),
                  ),
                  onTap: () =>
                      _showActivityDetails(activity), // Show details on tap
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
        backgroundColor: Colors.teal, // Ensure theme consistency
      ),
    );
  }
}
