import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../view_models/attendance_view_model.dart'; // නිවාඩු දත්ත ඇති ViewModel එක

class AdminLeaveRequestsScreen extends StatefulWidget {
  const AdminLeaveRequestsScreen({super.key});

  @override
  State<AdminLeaveRequestsScreen> createState() => _AdminLeaveRequestsScreenState();
}

class _AdminLeaveRequestsScreenState extends State<AdminLeaveRequestsScreen> {

  @override
  void initState() {
    super.initState();
    // පිටුව Load වන විටම දත්ත ලබා ගැනීම (Fetch) සිදු කරයි
    Future.microtask(() =>
        Provider.of<AttendanceViewModel>(context, listen: false).fetchLeaveRequests());
  }

  @override
  Widget build(BuildContext context) {
    // ViewModel එකට සම්බන්ධ වීම
    final attendanceVM = context.watch<AttendanceViewModel>();

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text("Leave Approvals",
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: Colors.deepOrange,
        centerTitle: true,
      ),
      body: attendanceVM.isLoading
          ? const Center(child: CircularProgressIndicator()) // දත්ත Load වන විට පෙන්වන රූපය
          : attendanceVM.leaveRequests.isEmpty
          ? const Center(child: Text("No pending leave requests at the moment."))
          : ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: attendanceVM.leaveRequests.length,
        itemBuilder: (context, index) {
          final leave = attendanceVM.leaveRequests[index];

          // Pending තත්වයේ ඇති ඒවා පමණක් පෙන්වීමට අවශ්‍ය නම් මෙතැනින් filter කළ හැක
          return Card(
            elevation: 3,
            margin: const EdgeInsets.only(bottom: 15),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(leave.employeeName,
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      _buildStatusBadge(leave.status),
                    ],
                  ),
                  const Divider(height: 20),
                  _buildDetailRow(Icons.category, "Type: ", leave.type),
                  _buildDetailRow(Icons.calendar_month, "Date: ", leave.date),
                  _buildDetailRow(Icons.info_outline, "Reason: ", leave.reason),

                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () => attendanceVM.updateLeaveStatus(leave.id, "Rejected"),
                          icon: const Icon(Icons.close, color: Colors.red),
                          label: const Text("REJECT", style: TextStyle(color: Colors.red)),
                          style: OutlinedButton.styleFrom(side: const BorderSide(color: Colors.red)),
                        ),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () => attendanceVM.updateLeaveStatus(leave.id, "Approved"),
                          icon: const Icon(Icons.check, color: Colors.white),
                          label: const Text("APPROVE", style: TextStyle(color: Colors.white)),
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
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

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 18, color: Colors.grey),
          const SizedBox(width: 10),
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
          Expanded(child: Text(value, style: const TextStyle(color: Colors.black87))),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    Color color = status == "Approved" ? Colors.green : (status == "Rejected" ? Colors.red : Colors.orange);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color),
      ),
      child: Text(status, style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 12)),
    );
  }
}