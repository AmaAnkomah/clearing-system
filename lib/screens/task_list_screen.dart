import 'package:flutter/material.dart';
import '../models/task.dart';

class TaskListScreen extends StatefulWidget {
  const TaskListScreen({Key? key}) : super(key: key);

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  final List<Task> _tasks = [
    Task(title: 'Assignment 1', courseCode: 'CSCD311', dueDate: DateTime.now().add(const Duration(days: 2))),
    Task(title: 'Midterm Prep', courseCode: 'CSCD315', dueDate: DateTime.now().add(const Duration(days: 5))),
    Task(title: 'Project Proposal', courseCode: 'CSCD313', dueDate: DateTime.now().add(const Duration(days: 7))),
  ];

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  void _showAddTaskDialog() {
    String newTitle = '';
    String newCourseCode = '';
    DateTime? selectedDate;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('Add New Task'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    decoration: const InputDecoration(labelText: 'Task Title'),
                    onChanged: (value) => newTitle = value,
                  ),
                  TextField(
                    decoration: const InputDecoration(labelText: 'Course Code'),
                    onChanged: (value) => newCourseCode = value,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Text(selectedDate == null 
                        ? 'No date selected' 
                        : 'Due: ${_formatDate(selectedDate!)}'),
                      const Spacer(),
                      TextButton(
                        onPressed: () async {
                          final DateTime? picked = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime.now(),
                            lastDate: DateTime(2030),
                          );
                          if (picked != null) {
                            setDialogState(() {
                              selectedDate = picked;
                            });
                          }
                        },
                        child: const Text('Select Date'),
                      )
                    ],
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (newTitle.isNotEmpty && newCourseCode.isNotEmpty && selectedDate != null) {
                      setState(() {
                        _tasks.add(Task(
                          title: newTitle,
                          courseCode: newCourseCode,
                          dueDate: selectedDate!,
                        ));
                      });
                      Navigator.pop(context);
                    }
                  },
                  child: const Text('Save'),
                ),
              ],
            );
          }
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tasks List'),
      ),
      body: ListView.builder(
        itemCount: _tasks.length,
        itemBuilder: (context, index) {
          final task = _tasks[index];
          return ListTile(
            title: Text(task.title),
            subtitle: Text('${task.courseCode} - Due: ${_formatDate(task.dueDate)}'),
            trailing: Checkbox(
              value: task.isComplete,
              onChanged: (bool? value) {
                if (value != null) {
                  setState(() {
                    task.isComplete = value;
                  });
                }
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddTaskDialog,
        child: const Icon(Icons.add),
      ),
    );
  }
}
