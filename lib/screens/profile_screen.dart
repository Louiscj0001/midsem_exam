import 'package:flutter/material.dart';
import 'package:midsem_exam/models/student.dart';
import 'task_list_screen.dart'; // will be created next

class ProfileScreen extends StatelessWidget {
  
  final Student student = Student(
    name: 'Yamoah Joseph',
    studentId: 'S12345',
    programName: 'Computer Science',
    level: 300,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          elevation: 4,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircleAvatar(
                  radius: 40,
                  child: Text(
                    student.name[0], // initial
                    style: TextStyle(fontSize: 30),
                  ),
                ),
                SizedBox(height: 16),
                Text('Name: ${student.name}', style: TextStyle(fontSize: 18)),
                Text('ID: ${student.studentId}'),
                Text('Programme: ${student.programName}'),
                Text('Level: ${student.level}'),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    
                  },
                  child: Text('Edit Profile'),
                ),
                ElevatedButton(
                  onPressed: () {
                    
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TaskListScreen(),
                      ),
                    );
                  },
                  child: Text('View Tasks'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}