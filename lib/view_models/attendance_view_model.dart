import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/attendance.dart';

// Leave Request Model (මෙය වෙනම model file එකක තිබිය යුතුයි)
class LeaveRequest {
  final String id;
  final String employeeName;
  final String type;
  final String date;
  final String reason;
  String status;

  LeaveRequest({
    required this.id,
    required this.employeeName,
    required this.type,
    required this.date,
    required this.reason,
    this.status = "Pending",
  });
}

class AttendanceViewModel extends ChangeNotifier {
  List<Attendance> _attendanceList = [];
  List<Attendance> get attendanceList => _attendanceList;
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<LeaveRequest> _leaveRequests = [];
  List<LeaveRequest> get leaveRequests => _leaveRequests;

  Future<bool> processAttendance({
    required String nic,
    required String name,
    required String dept,
    required bool isCheckIn,
  }) async {
    String today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    String now = DateFormat('hh:mm a').format(DateTime.now());

    try {
      if (isCheckIn) {
        bool alreadyCheckedIn = _attendanceList.any(
                (a) => a.employeeNic == nic && a.date == today
        );
        if (alreadyCheckedIn) return false;

        final newRecord = Attendance(
          employeeNic: nic,
          employeeName: name,
          department: dept,
          date: today,
          checkIn: now,
          status: "Present",
        );
        _attendanceList.add(newRecord);
      } else {
        int index = _attendanceList.indexWhere(
                (a) => a.employeeNic == nic && a.date == today
        );

        if (index != -1) {
          final existing = _attendanceList[index];
          _attendanceList[index] = Attendance(
            id: existing.id,
            employeeNic: existing.employeeNic,
            employeeName: existing.employeeName,
            department: existing.department,
            date: existing.date,
            checkIn: existing.checkIn,
            checkOut: now,
            status: existing.status,
          );
        } else {
          return false;
        }
      }
      notifyListeners();
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<void> fetchLeaveRequests() async {
    _isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(seconds: 1));

    _isLoading = false;
    notifyListeners();
  }

  Future<void> updateLeaveStatus(String id, String newStatus) async {
    int index = _leaveRequests.indexWhere((req) => req.id == id);
    if (index != -1) {
      _leaveRequests[index].status = newStatus;
      notifyListeners();
    }
  }
}