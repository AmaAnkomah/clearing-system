import 'package:flutter/material.dart';

// --- Data Models ---
enum ClearanceState { cleared, pending, actionRequired }

class ClearanceStatus {
  final String departmentName;
  final ClearanceState state;
  final String? feedback;
  final DateTime dateUpdated;

  ClearanceStatus({
    required this.departmentName,
    required this.state,
    this.feedback,
    required this.dateUpdated,
  });
}

// --- Dashboard Screen ---
class ClearanceDashboardScreen extends StatelessWidget {
  // Dummy data representing how it would look fetching from Firestore
  final List<ClearanceStatus> departments = [
    ClearanceStatus(
      departmentName: 'Library',
      state: ClearanceState.cleared,
      dateUpdated: DateTime.now().subtract(const Duration(days: 2)),
    ),
    ClearanceStatus(
      departmentName: 'Finance',
      state: ClearanceState.actionRequired,
      feedback: 'Unpaid tuition fee for Fall semester',
      dateUpdated: DateTime.now().subtract(const Duration(hours: 4)),
    ),
    ClearanceStatus(
      departmentName: 'Sports',
      state: ClearanceState.pending,
      dateUpdated: DateTime.now().subtract(const Duration(days: 5)),
    ),
    ClearanceStatus(
      departmentName: 'Academics',
      state: ClearanceState.cleared,
      dateUpdated: DateTime.now().subtract(const Duration(days: 10)),
    ),
  ];

  ClearanceDashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Clearance Dashboard'),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'My Progress',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'View your departmental clearance status below. Yellow means the department is still reviewing, Green means you are cleared, and Red requires your immediate attention.',
              style: TextStyle(color: Colors.black54),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: departments.length,
                itemBuilder: (context, index) {
                  return ClearanceCard(status: departments[index]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// --- Individual Department Card ---
class ClearanceCard extends StatelessWidget {
  final ClearanceStatus status;

  const ClearanceCard({Key? key, required this.status}) : super(key: key);

  // Helper method to determine color based on state
  Color _getStatusColor() {
    switch (status.state) {
      case ClearanceState.cleared:
        return Colors.green;
      case ClearanceState.pending:
        return Colors.orangeAccent; // Using orange instead of bright yellow for better text readability
      case ClearanceState.actionRequired:
        return Colors.red;
    }
  }

  // Helper method to determine string label based on state
  String _getStatusText() {
    switch (status.state) {
      case ClearanceState.cleared:
        return 'Cleared';
      case ClearanceState.pending:
        return 'Pending';
      case ClearanceState.actionRequired:
        return 'Action Required';
    }
  }

  // Helper method to determine icon based on state
  IconData _getStatusIcon() {
    switch (status.state) {
      case ClearanceState.cleared:
        return Icons.check_circle_outline;
      case ClearanceState.pending:
        return Icons.hourglass_empty;
      case ClearanceState.actionRequired:
        return Icons.error_outline;
    }
  }

  @override
  Widget build(BuildContext context) {
    final Color statusColor = _getStatusColor();

    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 16.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: statusColor.withOpacity(0.5), width: 1),
      ),
      child: Theme(
        // Use ExpansionTile theme to remove borders when expanded
        data: Theme.of(context).copyWith(
          dividerColor: Colors.transparent, 
        ),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          leading: CircleAvatar(
            backgroundColor: statusColor.withOpacity(0.1),
            child: Icon(
              _getStatusIcon(),
              color: statusColor,
            ),
          ),
          title: Text(
            status.departmentName,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 4.0),
            child: Row(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: statusColor,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  _getStatusText(),
                  style: TextStyle(
                    color: statusColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          children: [
            if (status.feedback != null) ...[
              const Divider(),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.05),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Department Feedback:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[800],
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      status.feedback!,
                      style: const TextStyle(fontSize: 15),
                    ),
                  ],
                ),
              ),
            ]
          ],
        ),
      ),
    );
  }
}
