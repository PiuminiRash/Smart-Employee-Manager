class Attendance {
  final String? id;
  final String employeeNic; // NIC eken thama employee wa identify karanne
  final String employeeName;
  final String date;
  final String checkIn;
  final String? checkOut;

  Attendance({
    this.id,
    required this.employeeNic,
    required this.employeeName,
    required this.date,
    required this.checkIn,
    this.checkOut,
  });

  factory Attendance.fromJson(Map<String, dynamic> json) {
    return Attendance(
      id: json['id'],
      employeeNic: json['employeeNic'] ?? '',
      employeeName: json['employeeName'] ?? '',
      date: json['date'] ?? '',
      checkIn: json['checkIn'] ?? '',
      checkOut: json['checkOut'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'employeeNic': employeeNic,
      'employeeName': employeeName,
      'date': date,
      'checkIn': checkIn,
      'checkOut': checkOut,
    };
  }
}