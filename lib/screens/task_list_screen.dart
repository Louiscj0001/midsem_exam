import 'package:flutter/material.dart';
import 'package:midsem_exam/models/task.dart';

class TaskListScreen extends StatelessWidget {
  
  final List<Task> tasks = [
    Task(
      title: 'Assignment 1',
      courseCode: 'CS101',
      dueDate: DateTime(2025, 4, 10),
    ),
    Task(
      title: 'Read Chapter 3',
      courseCode: 'CS102',
      dueDate: DateTime(2025, 4, 12),
    ),
    Task(
      title: 'Prepare Presentation',
      courseCode: 'CS103',
      dueDate: DateTime(2025, 4, 15),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tasks'),
      ),
      body: ListView.builder(
        itemCount: tasks.length,
        itemBuilder: (context, index) {
          final task = tasks[index];
          return ListTile(
            title: Text(task.title),
            subtitle: Text(task.courseCode),
            trailing: Text(
              '${task.dueDate.day.toString().padLeft(2, '0')}/'
              '${task.dueDate.month.toString().padLeft(2, '0')}/'
              '${task.dueDate.year}',
            ),
            leading: Checkbox(
              value: task.isComplete,
              onChanged: null, 
            ),
          );
        },
      ),
    );
  }
}