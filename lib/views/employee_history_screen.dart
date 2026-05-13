import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../view_models/attendance_view_model.dart';
import '../models/attendance.dart';

class EmployeeHistoryScreen extends StatelessWidget {
  final String employeeNic;

  const EmployeeHistoryScreen({super.key, required this.employeeNic});

  @override
  Widget build(BuildContext context) {
    final attendanceVM = Provider.of<AttendanceViewModel>(context);

    List<Attendance> myRecords = attendanceVM.attendanceList
        .where((record) => record.employeeNic == employeeNic)
        .toList()
        .reversed
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text("My Attendance History",
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: Colors.teal,
        elevation: 0,
        centerTitle: true,
      ),
      body: myRecords.isEmpty
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.history_toggle_off, size: 80, color: Colors.grey.withValues(alpha: 0.5)),
            const SizedBox(height: 10),
            const Text("No attendance records found yet.",
                style: TextStyle(color: Colors.grey, fontSize: 16)),
          ],
        ),
      )
          : ListView.builder(
        padding: const EdgeInsets.only(top: 10, bottom: 20), // EdgeInsets.only භාවිතා කළා
        itemCount: myRecords.length,
        itemBuilder: (context, index) {
          final record = myRecords[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            child: ListTile(
              contentPadding: const EdgeInsets.all(15),
              leading: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.teal.withValues(alpha: 0.1), // withValues භාවිතා කළා
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.calendar_today, color: Colors.teal),
              ),
              title: Text(
                record.date,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 5),
                  // Status Badge
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                    decoration: BoxDecoration(
                      color: record.status == "Late"
                          ? Colors.red.withValues(alpha: 0.1)
                          : Colors.green.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      record.status,
                      style: TextStyle(
                          color: record.status == "Late" ? Colors.red : Colors.green,
                          fontSize: 12,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                  ),
                ],
              ),
              trailing: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  // Check-In Time
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.arrow_downward, size: 14, color: Colors.green),
                      Text(" In: ${record.checkIn}",
                          style: const TextStyle(fontWeight: FontWeight.w600, color: Colors.green)),
                    ],
                  ),
                  const SizedBox(height: 4),
                  // Check-Out Time
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.arrow_upward, size: 14, color: Colors.orange),
                      Text(
                        " Out: ${record.checkOut ?? '--:--'}",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: record.checkOut == null ? Colors.grey : Colors.orange,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}