import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminPanel extends StatelessWidget {
  final String adminDept; // Passed from login (e.g., "Finance")

  AdminPanel({required this.adminDept});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("$adminDept Admin Panel")),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('clearance').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return Center(child: CircularProgressIndicator());

          final students = snapshot.data!.docs;

          return ListView.builder(
            itemCount: students.length,
            itemBuilder: (context, index) {
              var data = students[index].data() as Map<String, dynamic>;
              String currentStatus = data['status'][adminDept] ?? "Pending";

              return Card(
                margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  title: Text("Student ID: ${data['studentId']}"),
                  subtitle: Text("Current Status: $currentStatus"),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.check, color: Colors.green),
                        onPressed: () => _updateStatus(students[index].id, "Cleared"),
                      ),
                      IconButton(
                        icon: Icon(Icons.block, color: Colors.red),
                        onPressed: () => _showRejectDialog(context, students[index].id),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _updateStatus(String docId, String newStatus, {String remark = ""}) {
    FirebaseFirestore.instance.collection('clearance').doc(docId).update({
      'status.$adminDept': newStatus,
      'remarks.$adminDept': remark,
    });
  }

  void _showRejectDialog(BuildContext context, String docId) {
    TextEditingController _reasonController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Reason for Rejection"),
        content: TextField(
          controller: _reasonController,
          decoration: InputDecoration(hintText: "e.g., Owes GHS 150.00"),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text("Cancel")),
          ElevatedButton(
            onPressed: () {
              _updateStatus(docId, "Flagged", remark: _reasonController.text);
              Navigator.pop(context);
            },
            child: Text("Reject"),
          ),
        ],
      ),
    );
  }
}