import 'package:flutter/material.dart';
import 'new_activity_page.dart'; // นำเข้าไฟล์ NewActivityPage

class ActivityPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Activity'),
      ),
      body: ListView(
        children: [
          ListTile(
            title: Text('Working'),
            subtitle: Text('Doing things, doing homework, building applications.'),
            trailing: Text('Deadline: 8:00 a.m. 20/07/2024'),
          ),
          // เพิ่ม ListTile อื่นๆ สำหรับกิจกรรมอื่นๆ ได้ที่นี่
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => NewActivityPage()), // เรียก NewActivityPage
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
