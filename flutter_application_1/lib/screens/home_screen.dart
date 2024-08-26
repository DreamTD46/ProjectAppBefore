// home_screen.dart

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart'; // สำหรับการจัดรูปแบบเวลา
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
      final response = await http.get(Uri.parse('http://10.10.11.71/flutter/fetch.php'));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<dynamic> activities = data['activities'];

        setState(() {
          _activities = activities.map((activity) {
            // ใช้เวลาที่เก็บในฐานข้อมูล
            return {
              'id': activity['id'],
              'name': activity['activity_name'],
              'note': activity['description'],
              'dateTime': activity['activity_date'], // ใช้เวลาที่ได้จากฐานข้อมูล
            };
          }).toList();
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
        Uri.parse(activity['id'].isEmpty
            ? 'http://10.10.11.71/flutter/add_activity.php'
            : 'http://10.10.11.71/flutter/edit_activity.php'),
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: {
          'id': activity['id'] ?? '',
          'activity_name': activity['name'],
          'description': activity['note'],
          'activity_date': activity['dateTime'], // ใช้เวลาที่ผู้ใช้เลือก
        },
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        Fluttertoast.showToast(
          msg: responseData['message'],
          toastLength: Toast.LENGTH_SHORT,
        );

        if (!activity['id'].isEmpty) {
          _fetchActivities();
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
    final formattedDateTime = DateFormat('yyyy-MM-dd HH:mm:ss').format(dateTime); // ใช้รูปแบบที่ตรงตามเวลาที่ผู้ใช้เลือก

    final newActivity = {
      'id': index != null ? _activities[index]['id'] : '',
      'name': name,
      'note': note,
      'dateTime': formattedDateTime, // เก็บเวลาที่ผู้ใช้เลือก
    };

    setState(() {
      if (index != null) {
        _activities[index] = newActivity;
      } else {
        _activities.add(newActivity);
      }
    });

    await _saveActivityToDatabase(newActivity);
  }

  void _deleteActivity(int index) async {
    final activity = _activities[index];
    try {
      final response = await http.post(
        Uri.parse('http://10.10.11.71/flutter/delete_activity.php'),
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: {'id': activity['id']},
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
        backgroundColor: Colors.teal,
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
                    color: Colors.teal,
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
                color: Colors.teal,
              ),
            ),
          ],
        ),
      ),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: _activities.isEmpty
            ? Center(child: Text('No activities yet. Add some!', key: ValueKey('empty')))
            : ListView.builder(
          key: ValueKey('list'),
          itemCount: _activities.length,
          itemBuilder: (context, index) {
            final activity = _activities[index];
            final dateTime = DateTime.parse(activity['dateTime']); // ใช้เวลาที่เก็บไว้

            final formattedDate = DateFormat('yyyy-MM-dd').format(dateTime);
            final formattedTime = DateFormat('HH:mm').format(dateTime);

            return Card(
              color: Colors.white,
              margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: ListTile(
                contentPadding: EdgeInsets.all(16.0),
                title: Text(activity['name'], style: TextStyle(fontWeight: FontWeight.bold, color: Colors.teal)),
                subtitle: Text(activity['note']),
                trailing: Text(
                  "$formattedDate $formattedTime",
                  style: TextStyle(color: Colors.deepOrange),
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
        backgroundColor: Colors.teal,
      ),
    );
  }
}
