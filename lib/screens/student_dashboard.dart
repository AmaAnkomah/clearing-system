class StudentDashboard extends StatelessWidget {
  final String uid;
  StudentDashboard({required this.uid});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("My Clearance Status"), actions: [IconButton(icon: Icon(Icons.logout), onPressed: () => FirebaseAuth.instance.signOut())]),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance.collection('clearance').doc(uid).snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return Center(child: CircularProgressIndicator());
          var data = snapshot.data!.data() as Map<String, dynamic>;
          var status = data['status'] as Map<String, dynamic>;

          return ListView(
            padding: EdgeInsets.all(16),
            children: status.keys.map((dept) => Card(
              color: status[dept] == "Cleared" ? Colors.green[50] : Colors.orange[50],
              child: ListTile(
                title: Text(dept),
                subtitle: Text("Status: ${status[dept]}"),
                trailing: Icon(status[dept] == "Cleared" ? Icons.check_circle : Icons.pending, color: status[dept] == "Cleared" ? Colors.green : Colors.orange),
              ),
            )).toList(),
          );
        },
      ),
    );
  }
}