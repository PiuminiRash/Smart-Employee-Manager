class LeaveRequest {
  final String id;
  final String employeeNic;
  final String employeeName;
  final String leaveType;
  final String date;
  final String reason;
  String status;

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