import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../view_models/attendance_view_model.dart';

class AttendanceHistoryScreen extends StatelessWidget {
  const AttendanceHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final attendanceVM = Provider.of<AttendanceViewModel>(context);
    final history = attendanceVM.attendanceList;

    return Scaffold(
      appBar: AppBar(
        title: const Text("All Attendance Logs", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.brown,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: history.isEmpty
          ? const Center(child: Text("No attendance records found."))
          : ListView.builder(
        padding: const EdgeInsets.all(10),
        itemCount: history.length,
        itemBuilder: (context, index) {
          final record = history[index];
          return Card(
            elevation: 2,
            margin: const EdgeInsets.symmetric(vertical: 8),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: record.status == "Present" ? Colors.green : Colors.red,
                child: const Icon(Icons.person, color: Colors.white),
              ),
              title: Text(record.employeeName, style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("NIC: ${record.employeeNic}"),
                  Text("Date: ${record.date} | In: ${record.checkIn} | Out: ${record.checkOut ?? 'N/A'}"),
                ],
              ),
              trailing: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: _getStatusColor(record.status).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: _getStatusColor(record.status)),
                ),
                child: Text(
                  record.status,
                  style: TextStyle(color: _getStatusColor(record.status), fontWeight: FontWeight.bold, fontSize: 12),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // Status එක අනුව වර්ණය තෝරා ගැනීම
  Color _getStatusColor(String status) {
    switch (status) {
      case "Present": return Colors.green;
      case "Late": return Colors.orange;
      case "Absent": return Colors.red;
      default: return Colors.blue;
    }
  }
}