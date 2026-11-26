class StudentClearance {
  final String uid;
  final String studentId; // e.g., 224CS02001273
  final Map<String, dynamic> status; // { "Library": "Pending", "Finance": "Cleared" }
  final Map<String, String> remarks; // { "Library": "Return book 'AI Basics'" }

  StudentClearance({required this.uid, required this.studentId, required this.status, required this.remarks});

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'studentId': studentId,
      'status': status,
      'remarks': remarks,
      'isFinalized': !status.values.any((s) => s != "Cleared"),
    };
  }
}