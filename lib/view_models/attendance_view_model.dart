import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/attendance.dart';

class AttendanceViewModel extends ChangeNotifier {
  List<Attendance> _attendanceList = [];
  List<Attendance> get attendanceList => _attendanceList;

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
}