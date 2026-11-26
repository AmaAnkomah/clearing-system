import 'package:flutter/material.dart';
import '../models/student.dart';
import 'task_list_screen.dart';

class ProfileScreen extends StatelessWidget {
  final Student student = Student(
    name: 'Jane Doe',
    studentId: '10987654',
    programme: 'BSc Computer Science',
    level: 300,
  );

  ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            CircleAvatar(
              radius: 50,
              child: Text(
                student.name.isNotEmpty ? student.name[0] : '?',
                style: const TextStyle(fontSize: 40),
              ),
            ),
            const SizedBox(height: 20),
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Name: ${student.name}', style: const TextStyle(fontSize: 18)),
                    const SizedBox(height: 10),
                    Text('ID: ${student.studentId}', style: const TextStyle(fontSize: 18)),
                    const SizedBox(height: 10),
                    Text('Programme: ${student.programme}', style: const TextStyle(fontSize: 18)),
                    const SizedBox(height: 10),
                    Text('Level: ${student.level}', style: const TextStyle(fontSize: 18)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Edit profile functionality not required
              },
              child: const Text('Edit Profile'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const TaskListScreen()),
                );
              },
              child: const Text('View Tasks'),
            ),
          ],
        ),
      ),
    );
  }
}
