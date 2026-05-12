class Attendance {
  final String? id;
  final String employeeNic;  // සේවකයා හඳුනාගැනීමට (Primary Key ලෙස)
  final String employeeName;
  final String department;   // වාර්තා වර්ගීකරණය සඳහා (Filtering)
  final String date;         // දිනය (YYYY-MM-DD)
  final String checkIn;      // ඇතුළු වූ වේලාව
  final String? checkOut;    // පිටවූ වේලාව (මුලින් null විය හැක)
  final String status;       // 'Present', 'Late', 'Half Day' වැනි තත්ත්වයන්

  Attendance({
    this.id,
    required this.employeeNic,
    required this.employeeName,
    required this.department, // අනිවාර්යයෙන්ම අවශ්‍යයි
    required this.date,
    required this.checkIn,
    this.checkOut,
    this.status = 'Present',  // Default අගය Present ලෙස ලබා දී ඇත
  });

  // JSON වලින් Data ලබා ගැනීම (API/Database එකෙන් එන දත්ත)
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

  // API එකට Data යැවීම (Save/Update සඳහා)
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