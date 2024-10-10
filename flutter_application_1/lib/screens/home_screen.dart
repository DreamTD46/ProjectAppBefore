// home_screen.dart

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
<<<<<<< HEAD
import 'package:intl/intl.dart'; // สำหรับการจัดรูปแบบวันที่และเวลา
=======
import 'package:intl/intl.dart'; // สำหรับการจัดรูปแบบเวลา
>>>>>>> 397857386c3cabe38132a674b264d33e15ce71c3
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
<<<<<<< HEAD
      final response =
          await http.get(Uri.parse('http://192.168.1.35/flutter/fetch.php'));
=======
      final response = await http.get(Uri.parse('http://10.10.11.71/flutter/fetch.php'));
>>>>>>> 397857386c3cabe38132a674b264d33e15ce71c3

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<dynamic> activities = data['activities'];

        setState(() {
          _activities = activities.map((activity) {
<<<<<<< HEAD
=======
            // ใช้เวลาที่เก็บในฐานข้อมูล
>>>>>>> 397857386c3cabe38132a674b264d33e15ce71c3
            return {
              'id': activity['id'],
              'name': activity['activity_name'],
              'note': activity['description'],
<<<<<<< HEAD
              'date': activity['activity_date'],
              'time': activity['activity_time'],
            };
          }).toList();
          // เรียงลำดับกิจกรรมตามวันที่และเวลา
          _activities.sort((a, b) {
            final dateA = DateTime.parse('${a['date']} ${a['time']}');
            final dateB = DateTime.parse('${b['date']} ${b['time']}');
            return dateA.compareTo(dateB);
          });
=======
              'dateTime': activity['activity_date'], // ใช้เวลาที่ได้จากฐานข้อมูล
            };
          }).toList();
>>>>>>> 397857386c3cabe38132a674b264d33e15ce71c3
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
<<<<<<< HEAD
            ? 'http://192.168.1.35/flutter/add_activity.php'
            : 'http://192.168.1.35/flutter/edit_activity.php'),
=======
            ? 'http://10.10.11.71/flutter/add_activity.php'
            : 'http://10.10.11.71/flutter/edit_activity.php'),
>>>>>>> 397857386c3cabe38132a674b264d33e15ce71c3
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: {
          'id': activity['id'] ?? '',
          'activity_name': activity['name'],
          'description': activity['note'],
<<<<<<< HEAD
          'activity_date': activity['date'],
          'activity_time': activity['time'],
=======
          'activity_date': activity['dateTime'], // ใช้เวลาที่ผู้ใช้เลือก
>>>>>>> 397857386c3cabe38132a674b264d33e15ce71c3
        },
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
<<<<<<< HEAD
        _showCustomDialog(responseData['message']); // แสดงป๊อปอัพ

        if (activity['id'].isEmpty) {
=======
        Fluttertoast.showToast(
          msg: responseData['message'],
          toastLength: Toast.LENGTH_SHORT,
        );

        if (!activity['id'].isEmpty) {
>>>>>>> 397857386c3cabe38132a674b264d33e15ce71c3
          _fetchActivities();
        }
      } else {
        _showCustomDialog('Error: ${response.reasonPhrase}'); // แสดงป๊อปอัพ
      }
    } catch (e) {
      _showCustomDialog('Error saving activity: $e'); // แสดงป๊อปอัพ
    }
  }

<<<<<<< HEAD
  void _addActivity(String name, String note, DateTime dateTime,
      [int? index]) async {
=======
  void _addActivity(String name, String note, DateTime dateTime, [int? index]) async {
    final formattedDateTime = DateFormat('yyyy-MM-dd HH:mm:ss').format(dateTime); // ใช้รูปแบบที่ตรงตามเวลาที่ผู้ใช้เลือก

>>>>>>> 397857386c3cabe38132a674b264d33e15ce71c3
    final newActivity = {
      'id': index != null ? _activities[index]['id'] : '',
      'name': name,
      'note': note,
<<<<<<< HEAD
      'date': DateFormat('yyyy-MM-dd').format(dateTime),
      'time': DateFormat('HH:mm:ss').format(dateTime),
=======
      'dateTime': formattedDateTime, // เก็บเวลาที่ผู้ใช้เลือก
>>>>>>> 397857386c3cabe38132a674b264d33e15ce71c3
    };

    setState(() {
      if (index != null) {
        _activities[index] = newActivity;
      } else {
        _activities.add(newActivity);
      }
      // เรียงลำดับกิจกรรมใหม่หลังจากเพิ่มหรือแก้ไข
      _activities.sort((a, b) {
        final dateA = DateTime.parse('${a['date']} ${a['time']}');
        final dateB = DateTime.parse('${b['date']} ${b['time']}');
        return dateA.compareTo(dateB);
      });
    });

    // Save to the database
    await _saveActivityToDatabase(newActivity);
  }

  void _deleteActivity(int index) async {
    final activity = _activities[index];
    try {
      final response = await http.post(
<<<<<<< HEAD
        Uri.parse('http://192.168.1.35/flutter/delete_activity.php'),
=======
        Uri.parse('http://10.10.11.71/flutter/delete_activity.php'),
>>>>>>> 397857386c3cabe38132a674b264d33e15ce71c3
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: {'id': activity['id']},
      );

      if (response.statusCode == 200) {
        setState(() {
          _activities.removeAt(index);
        });
        _showCustomDialog('Activity deleted successfully.'); // แสดงป๊อปอัพ
      } else {
        throw Exception('Failed to delete activity');
      }
    } catch (e) {
      print('Error deleting activity: $e');
      _showCustomDialog('Error deleting activity: $e'); // แสดงป๊อปอัพ
    }
  }

void _showCustomDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Container(
            padding: EdgeInsets.all(8.0), // เพิ่ม Padding รอบๆ
            decoration: BoxDecoration(
              color: Colors.teal, // ตั้งค่าสีพื้นหลังเป็นสี teal
              borderRadius: BorderRadius.circular(8.0), // ทำมุมให้โค้ง
            ),
            child: Text(
              'Notification',
              style:
                  TextStyle(color: Colors.white), // เปลี่ยนสีตัวอักษรเป็นสีขาว
            ),
          ),
          content: Text(
            message,
            style: TextStyle(color: Colors.black), // เปลี่ยนเป็นสีดำ
          ),
          actions: <Widget>[
            TextButton(
              child: Text('OK',
                  style: TextStyle(
                      color: Colors.teal)), // ปล่อยสีปุ่ม OK ไว้เหมือนเดิม
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
          backgroundColor: Colors.white, // ตั้งค่าสีพื้นหลังเป็นสีขาว
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    // จัดกลุ่มกิจกรรมตามวันที่
    Map<String, List<Map<String, dynamic>>> groupedActivities = {};
    for (var activity in _activities) {
      final date = activity['date'];
      if (!groupedActivities.containsKey(date)) {
        groupedActivities[date] = [];
      }
      groupedActivities[date]!.add(activity);
    }

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
                      icon: Icon(Icons.account_circle,
                          color: Colors.white, size: 40),
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
<<<<<<< HEAD
      body: Container(
        padding: EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.grey[200],
        ),
        child: groupedActivities.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.info_outline, size: 80, color: Colors.teal),
                    SizedBox(height: 20),
                    Text('No activities yet. Add some!',
                        style: TextStyle(
                            color: Colors.teal,
                            fontSize: 20,
                            fontWeight: FontWeight.bold)),
                  ],
                ),
              )
            : ListView(
                children: groupedActivities.entries.map((entry) {
                  String date = entry.key;
                  List<Map<String, dynamic>> activities = entry.value;

                  // เรียงลำดับกิจกรรมตามเวลา
                  activities.sort((a, b) {
                    final timeA = DateTime.parse('${a['date']} ${a['time']}');
                    final timeB = DateTime.parse('${b['date']} ${b['time']}');
                    return timeA.compareTo(timeB);
                  });

                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 8.0),
                    child: ExpansionTile(
                      title: Text(
                        DateFormat('EEEE, d MMMM yyyy')
                            .format(DateTime.parse(date)),
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      children: activities.map((activity) {
                        final dateTime = DateTime.parse(
                            '${activity['date']} ${activity['time']}');

                        return ListTile(
                          title: Text(activity['name']),
                          subtitle: Text(activity['note']),
                          trailing:
                              Text(DateFormat('HH:mm:ss').format(dateTime)),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ActivityDetailScreen(
                                  activity: activity,
                                  index: _activities.indexOf(activity),
                                  onSave: _addActivity,
                                  onDelete: _deleteActivity,
                                ),
                              ),
                            );
                          },
                        );
                      }).toList(),
                    ),
                  );
                }).toList(),
              ),
      ),
floatingActionButton: FloatingActionButton(
  onPressed: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NewActivityScreen(
          onAdd: (name, note, dateTime) {
            _addActivity(name, note, dateTime); // ส่งพารามิเตอร์ไปยังฟังก์ชัน _addActivity
          },
        ),
=======
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
>>>>>>> 397857386c3cabe38132a674b264d33e15ce71c3
      ),
    );
  },
  backgroundColor: Colors.teal,
  child: Icon(Icons.add),
),
    );
  }
}
