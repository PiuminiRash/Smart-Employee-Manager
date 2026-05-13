import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../models/employee.dart';
import '../view_models/attendance_view_model.dart';
import 'employee_history_screen.dart';
import 'employee_salary_screen.dart';
import 'employee_leave_request_screen.dart';
import 'login_screen.dart';

class EmployeeDashboard extends StatefulWidget {
  final Employee employee;

  const EmployeeDashboard({super.key, required this.employee});

  @override
  State<EmployeeDashboard> createState() => _EmployeeDashboardState();
}

class _EmployeeDashboardState extends State<EmployeeDashboard> {
  bool _isCheckedIn = false;
  String _statusMessage = "You haven't marked attendance today.";

  void _handleAttendance(bool isCheckIn) async {
    final attendanceVM = Provider.of<AttendanceViewModel>(context, listen: false);

    bool success = await attendanceVM.processAttendance(
      nic: widget.employee.nic,
      name: widget.employee.name,
      dept: widget.employee.department,
      isCheckIn: isCheckIn,
    );

    if (success) {
      String currentTime = DateFormat('hh:mm a').format(DateTime.now());
      setState(() {
        _isCheckedIn = isCheckIn;
        _statusMessage = isCheckIn
            ? "Checked In at $currentTime"
            : "Checked Out at $currentTime";
      });
      _showSnackBar("Attendance marked successfully!", Colors.green);
    } else {
      _showSnackBar("Action failed or already marked.", Colors.orange);
    }
  }

  void _showSnackBar(String msg, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(msg), backgroundColor: color, behavior: SnackBarBehavior.floating)
    );
  }

  @override
  Widget build(BuildContext context) {
    final attendanceVM = Provider.of<AttendanceViewModel>(context);

    int totalDays = attendanceVM.attendanceList
        .where((a) => a.employeeNic == widget.employee.nic).length;
    int lateDays = attendanceVM.attendanceList
        .where((a) => a.employeeNic == widget.employee.nic && a.status == "Late").length;

    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FA),
      appBar: AppBar(
        title: const Text("Employee Workspace",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.indigo,
        elevation: 0,
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                      (route) => false
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildProfileHeader(),

            // --- 1. DAILY ATTENDANCE SECTION ---
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
                ),
                child: Column(
                  children: [
                    const Text("Daily Attendance", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 10),
                    Text(_statusMessage, style: TextStyle(color: Colors.grey[600], fontSize: 13)),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: _attendanceBtn("Check In", Icons.login, Colors.green, !_isCheckedIn, true),
                        ),
                        const SizedBox(width: 15),
                        Expanded(
                          child: _attendanceBtn("Check Out", Icons.logout, Colors.orange, _isCheckedIn, false),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // --- 2. QUICK MENU GRID ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 3,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                children: [
                  _menuItem(context, "History", Icons.history, Colors.teal,
                      EmployeeHistoryScreen(employeeNic: widget.employee.nic)),
                  _menuItem(context, "Paysheet", Icons.description, Colors.blue,
                      EmployeeSalaryScreen(employee: widget.employee)),
                  _menuItem(context, "Leave", Icons.event_note, Colors.purple,
                      LeaveRequestScreen(employee: widget.employee)),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // --- 3. SUMMARY DETAILS SECTION ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Monthly Summary",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.indigo)),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      _summaryCard("Total Present", "$totalDays Days", Icons.calendar_month, Colors.blue),
                      const SizedBox(width: 10),
                      _summaryCard("Late Arrivals", "$lateDays Days", Icons.timer_outlined, Colors.red),
                    ],
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(25),
      decoration: const BoxDecoration(
        color: Colors.indigo,
        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(30), bottomRight: Radius.circular(30)),
      ),
      child: Column(
        children: [
          const CircleAvatar(radius: 40, backgroundColor: Colors.white,
              child: Icon(Icons.person, size: 50, color: Colors.indigo)),
          const SizedBox(height: 15),
          Text(widget.employee.name,
              style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
          Text(widget.employee.designation, style: const TextStyle(color: Colors.white70)),
        ],
      ),
    );
  }

  Widget _attendanceBtn(String label, IconData icon, Color color, bool enabled, bool isCheckIn) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        disabledBackgroundColor: Colors.grey[300],
        padding: const EdgeInsets.symmetric(vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      onPressed: enabled ? () => _handleAttendance(isCheckIn) : null,
      icon: Icon(icon, size: 18),
      label: Text(label, style: const TextStyle(fontSize: 14)),
    );
  }

  Widget _summaryCard(String title, String value, IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: color.withOpacity(0.2)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 8),
            Text(title, style: const TextStyle(color: Colors.grey, fontSize: 12)),
            const SizedBox(height: 2),
            Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Widget _menuItem(BuildContext context, String title, IconData icon, Color color, Widget? target) {
    return InkWell(
      onTap: () {
        if (target != null) Navigator.push(context, MaterialPageRoute(builder: (context) => target));
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 5)],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 28, color: color),
            const SizedBox(height: 5),
            Text(title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12)),
          ],
        ),
      ),
    );
  }
}