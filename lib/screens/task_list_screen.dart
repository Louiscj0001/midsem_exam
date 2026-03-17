import 'package:flutter/material.dart';
import 'package:midsem_exam/models/task.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class TaskListScreen extends StatefulWidget {
  @override
  _TaskListScreenState createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  List<Task> tasks = [];

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  // Load tasks from SharedPreferences
  Future<void> _loadTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final String? tasksJson = prefs.getString('tasks');
    if (tasksJson != null) {
      final List<dynamic> decoded = jsonDecode(tasksJson);
      setState(() {
        tasks = decoded.map((item) => Task(
          title: item['title'],
          courseCode: item['courseCode'],
          dueDate: DateTime.parse(item['dueDate']),
          isComplete: item['isComplete'],
        )).toList();
      });
    } else {
      // Default hardcoded tasks if no saved data
      tasks = [
        Task(title: 'Assignment 1', courseCode: 'CS101', dueDate: DateTime(2025, 4, 10)),
        Task(title: 'Read Chapter 3', courseCode: 'CS102', dueDate: DateTime(2025, 4, 12)),
        Task(title: 'Prepare Presentation', courseCode: 'CS103', dueDate: DateTime(2025, 4, 15)),
      ];
    }
  }

  // Save tasks to SharedPreferences
  Future<void> _saveTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final List<Map<String, dynamic>> tasksMap = tasks.map((task) => {
      'title': task.title,
      'courseCode': task.courseCode,
      'dueDate': task.dueDate.toIso8601String(),
      'isComplete': task.isComplete,
    }).toList();
    await prefs.setString('tasks', jsonEncode(tasksMap));
  }

  // Add a new task
  void _addTask(Task task) {
    setState(() {
      tasks.add(task);
    });
    _saveTasks();
  }

  // Toggle completion status
  void _toggleComplete(int index) {
    setState(() {
      tasks[index].isComplete = !tasks[index].isComplete;
    });
    _saveTasks();
  }

  // Delete all tasks (required method name)
  void handleDeleteList() {
    setState(() {
      tasks.clear();
    });
    _saveTasks();
  }

  // Show dialog to add a new task
  void _showAddTaskDialog() {
    final titleController = TextEditingController();
    final courseController = TextEditingController();
    DateTime selectedDate = DateTime.now();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add New Task'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: InputDecoration(labelText: 'Task Title'),
              ),
              TextField(
                controller: courseController,
                decoration: InputDecoration(labelText: 'Course Code'),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: () async {
                  final DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: selectedDate,
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2100),
                  );
                  if (picked != null && picked != selectedDate) {
                    selectedDate = picked;
                  }
                },
                child: Text('Select Due Date'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (titleController.text.isNotEmpty &&
                    courseController.text.isNotEmpty) {
                  final newTask = Task(
                    title: titleController.text,
                    courseCode: courseController.text,
                    dueDate: selectedDate,
                  );
                  _addTask(newTask);
                  Navigator.pop(context);
                }
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tasks'),
        actions: [
          IconButton(
            icon: Icon(Icons.delete_sweep),
            onPressed: () {
              // Optional: show confirmation dialog before deleting all
              showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: Text('Delete All Tasks'),
                  content: Text('Are you sure?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(ctx),
                      child: Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () {
                        handleDeleteList();
                        Navigator.pop(ctx);
                      },
                      child: Text('Delete'),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
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
              onChanged: (value) => _toggleComplete(index),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddTaskDialog,
        child: Icon(Icons.add),
      ),
    );
  }
}