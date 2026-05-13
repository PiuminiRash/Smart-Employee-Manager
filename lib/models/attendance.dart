class Attendance {
  final String? id;
  final String employeeNic;
  final String employeeName;
  final String department;
  final String date;
  final String checkIn;
  final String? checkOut;
  final String status;

  Attendance({
    this.id,
    required this.employeeNic,
    required this.employeeName,
    required this.department,
    required this.date,
    required this.checkIn,
    this.checkOut,
    this.status = 'Present',
  });

  factory Attendance.fromJson(Map<String, dynamic> json) {
    return Attendance(
      id: json['id'],
      employeeNic: json['employeeNic'] ?? '',
      employeeName: json['employeeName'] ?? '',
      department: json['department'] ?? '',
      date: json['date'] ?? '',
      checkIn: json['checkIn'] ?? '',
      checkOut: json['checkOut'],
      status: json['status'] ?? 'Present',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'employeeNic': employeeNic,
      'employeeName': employeeName,
      'department': department,
      'date': date,
      'checkIn': checkIn,
      'checkOut': checkOut,
      'status': status,
    };
  }
}