class LeaveRequest {
  final String id;
  final String employeeNic;
  final String employeeName;
  final String leaveType; // e.g., Sick, Annual, Casual
  final String date;
  final String reason;
  String status; // Pending, Approved, Rejected

  LeaveRequest({
    required this.id,
    required this.employeeNic,
    required this.employeeName,
    required this.leaveType,
    required this.date,
    required this.reason,
    this.status = "Pending",
  });
}