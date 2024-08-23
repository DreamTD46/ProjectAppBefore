import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'new_activity_screen.dart';
import 'activity_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Map<String, dynamic>> _activities = [];

  @override
  void initState() {
    super.initState();
    _fetchActivities();
  }

  Future<void> _fetchActivities() async {
    try {
      final response = await http.get(Uri.parse('http://10.10.11.238/flutter/fetch.php'));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          _activities = data.map((activity) => activity as Map<String, dynamic>).toList();
        });
      } else {
        throw Exception('Failed to load activities');
      }
    } catch (e) {
      print('Error fetching activities: $e');
    }
  }

  Future<void> _saveActivityToDatabase(Map<String, dynamic> activity) async {
    try {
      final response = await http.post(
        Uri.parse('http://10.10.11.238/flutter/add_activity.php'),
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: {
          'id': activity['id'] ?? '', // Include 'id' for updates
          'name': activity['name'],
          'note': activity['note'],
          'dateTime': activity['dateTime'],
        },
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        if (responseData['status'] == 'success') {
          Fluttertoast.showToast(
            msg: responseData['message'],
            toastLength: Toast.LENGTH_SHORT,
          );
        } else {
          Fluttertoast.showToast(
            msg: responseData['message'],
            toastLength: Toast.LENGTH_SHORT,
          );
        }
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

  void _addActivity(String name, String note, DateTime dateTime, [int? index]) async {
    final newActivity = {
      'id': index != null ? _activities[index]['id'] : '', // Include 'id' for updates
      'name': name,
      'note': note,
      'dateTime': dateTime.toIso8601String(),
    };

    setState(() {
      if (index != null) {
        // Update existing activity
        _activities[index] = newActivity;
      } else {
        // Add new activity
        _activities.add(newActivity);
      }
    });

    await _saveActivityToDatabase(newActivity);
  }

  void _deleteActivity(int index) async {
    final activity = _activities[index];
    try {
      final response = await http.post(
        Uri.parse('http://10.10.11.238/flutter/delete_activity.php'),
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: {'id': activity['id']}, // Assuming 'id' is an identifier for the activity
      );

      if (response.statusCode == 200) {
        setState(() {
          _activities.removeAt(index);
        });
      } else {
        throw Exception('Failed to delete activity');
      }
    } catch (e) {
      print('Error deleting activity: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: Stack(
          children: <Widget>[
            ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                DrawerHeader(
                  decoration: BoxDecoration(
                    color: Colors.blue,
                  ),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: IconButton(
                      icon: Icon(Icons.account_circle, color: Colors.white, size: 40),
                      onPressed: () {
                        Navigator.pushReplacementNamed(context, '/login');
                      },
                    ),
                  ),
                ),
                ListTile(
                  title: Text('About'),
                  onTap: () {
                    // Navigate to about screen
                  },
                ),
              ],
            ),
            Positioned(
              right: 16,
              bottom: 16,
              child: IconButton(
                icon: Icon(Icons.settings),
                onPressed: () {
                  Navigator.pushNamed(context, '/settings');
                },
              ),
            ),
          ],
        ),
      ),
      body: _activities.isEmpty
          ? Center(child: Text('No activities yet. Add some!'))
          : ListView.builder(
        itemCount: _activities.length,
        itemBuilder: (context, index) {
          final activity = _activities[index];
          final dateTime = DateTime.parse(activity['dateTime']);
          return Card(
            color: const Color.fromARGB(255, 255, 255, 255),
            margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            elevation: 4,
            child: ListTile(
              contentPadding: EdgeInsets.all(16.0),
              title: Text(activity['name']),
              subtitle: Text(activity['note']),
              trailing: Text(
                "${dateTime.toLocal()}".split(' ')[0] +
                    " " +
                    dateTime.hour.toString().padLeft(2, '0') +
                    ":" +
                    dateTime.minute.toString().padLeft(2, '0'),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ActivityDetailScreen(
                      activity: activity,
                      index: index,
                      onSave: _addActivity,
                      onDelete: _deleteActivity,
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => NewActivityScreen(onAdd: _addActivity),
            ),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
