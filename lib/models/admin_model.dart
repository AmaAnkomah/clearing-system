class AdminUser {
  final String uid;
  final String department; // e.g., "Library" or "Finance"
  final String role; // Always "Admin"

  AdminUser({required this.uid, required this.department, this.role = "Admin"});
}