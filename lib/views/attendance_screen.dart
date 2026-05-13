import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/employee.dart';
import '../view_models/employee_view_model.dart';
import '../view_models/attendance_view_model.dart';

class AttendanceScreen extends StatefulWidget {
  const AttendanceScreen({super.key});

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  final TextEditingController _nicController = TextEditingController();
  bool _isProcessing = false;

  @override
  void dispose() {
    _nicController.dispose();
    super.dispose();
  }

  void _handleAttendance(bool isCheckIn) async {
    final employeeVM = Provider.of<EmployeeViewModel>(context, listen: false);
    final attendanceVM = Provider.of<AttendanceViewModel>(context, listen: false);

    String nicInput = _nicController.text.trim();

    if (nicInput.isEmpty) {
      _showMsg("Please enter your NIC number", Colors.redAccent);
      return;
    }

    setState(() => _isProcessing = true);

    final Employee employee = employeeVM.employees.firstWhere(
          (emp) => emp.nic == nicInput,
      orElse: () => Employee(nic: '', name: '', role: '', email: '', department: '', designation: '', salary: 0),
    );

    if (employee.nic.isEmpty) {
      _showMsg("Employee not found! Please check the NIC.", Colors.orange);
      setState(() => _isProcessing = false);
      return;
    }

    bool success = await attendanceVM.processAttendance(
      nic: employee.nic,
      name: employee.name,
      dept: employee.department,
      isCheckIn: isCheckIn,
    );

    if (success) {
      _showMsg(
          "${employee.name} ${isCheckIn ? 'Checked In' : 'Checked Out'} Successfully!",
          Colors.green
      );
      _nicController.clear();
    } else {
      String errorMsg = isCheckIn
          ? "Already checked in for today!"
          : "You must Check-In before Checking-Out!";
      _showMsg(errorMsg, Colors.orange);
    }

    setState(() => _isProcessing = false);
  }

  void _showMsg(String msg, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(msg, style: const TextStyle(fontWeight: FontWeight.bold)),
          backgroundColor: color,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          margin: const EdgeInsets.all(15),
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Mark Attendance", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.teal,
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Top Header Icon
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 40),
              decoration: const BoxDecoration(
                color: Colors.teal,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: const Icon(Icons.qr_code_scanner, size: 100, color: Colors.white),
            ),

            Padding(
              padding: const EdgeInsets.all(25.0),
              child: Column(
                children: [
                  const Text(
                    "Welcome! Please enter your NIC",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 20),

                  // NIC Input Field
                  TextField(
                    controller: _nicController,
                    enabled: !_isProcessing,
                    decoration: InputDecoration(
                      labelText: "NIC Number",
                      hintText: "e.g. 981234567V",
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                      prefixIcon: const Icon(Icons.badge_outlined),
                      filled: true,
                      fillColor: Colors.grey[100],
                    ),
                  ),
                  const SizedBox(height: 30),

                  // Action Buttons
                  Row(
                    children: [
                      Expanded(
                        child: _attendanceButton(
                          label: "Check In",
                          icon: Icons.login,
                          color: Colors.green,
                          isLoading: _isProcessing,
                          onPressed: () => _handleAttendance(true),
                        ),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: _attendanceButton(
                          label: "Check Out",
                          icon: Icons.logout,
                          color: Colors.orange,
                          isLoading: _isProcessing,
                          onPressed: () => _handleAttendance(false),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _attendanceButton({
    required String label,
    required IconData icon,
    required Color color,
    required bool isLoading,
    required VoidCallback onPressed
  }) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 18),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 5,
      ),
      onPressed: isLoading ? null : onPressed,
      icon: isLoading
          ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
          : Icon(icon),
      label: Text(label, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
    );
  }
}