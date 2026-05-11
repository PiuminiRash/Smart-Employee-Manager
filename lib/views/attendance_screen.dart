import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../models/employee.dart';
import '../view_models/employee_view_model.dart';

class AttendanceScreen extends StatefulWidget {
  const AttendanceScreen({super.key});

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  final TextEditingController _nicController = TextEditingController();

  @override
  void dispose() {
    _nicController.dispose();
    super.dispose();
  }

  // Attendance එක handle කරන ප්‍රධාන function එක
  void _handleAttendance(bool isCheckIn) async {
    final viewModel = Provider.of<EmployeeViewModel>(context, listen: false);
    String nicInput = _nicController.text.trim();

    // 1. Input එක හිස්දැයි බැලීම
    if (nicInput.isEmpty) {
      _showMsg("Please enter your NIC number", Colors.redAccent);
      return;
    }

    // 2. සේවකයා අපේ system එකේ ඉන්නවද කියලා NIC එකෙන් check කරනවා
    // firstWhere පාවිච්චි කරලා අදාළ employee object එක ගන්නවා
    final Employee employee = viewModel.employees.firstWhere(
          (emp) => emp.nic == nicInput,
      orElse: () => Employee(nic: '', name: '', department: '', designation: '', salary: 0),
    );

    if (employee.nic.isEmpty) {
      _showMsg("Employee not found! Please check the NIC.", Colors.orange);
      return;
    }

    // 3. Date සහ Time සකසා ගැනීම
    String currentTime = DateFormat('hh:mm a').format(DateTime.now());
    String currentDate = DateFormat('yyyy-MM-dd').format(DateTime.now());

    // 4. API එකට යවන්න ඕන data structure එක (මෙය පසුව ViewModel එකට සම්බන්ධ කරන්න)
    Map<String, dynamic> attendanceRecord = {
      "employeeNic": employee.nic,
      "employeeName": employee.name,
      "date": currentDate,
      "status": isCheckIn ? "In" : "Out",
      "time": currentTime,
    };

    // දැනට UI එකේ සාර්ථකයි කියලා පෙන්වනවා
    _showMsg(
        "${employee.name} ${isCheckIn ? 'Checked In' : 'Checked Out'} at $currentTime",
        Colors.green
    );

    debugPrint("Attendance Log: $attendanceRecord"); // Debugging සඳහා
    _nicController.clear();
  }

  void _showMsg(String msg, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(msg),
          backgroundColor: color,
          behavior: SnackBarBehavior.floating,
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
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
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
                  TextField(
                    controller: _nicController,
                    decoration: InputDecoration(
                      labelText: "NIC Number",
                      hintText: "e.g. 981234567V",
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                      prefixIcon: const Icon(Icons.badge_outlined),
                    ),
                  ),
                  const SizedBox(height: 30),
                  Row(
                    children: [
                      Expanded(
                        child: _attendanceButton(
                          label: "Check In",
                          icon: Icons.login,
                          color: Colors.green,
                          onPressed: () => _handleAttendance(true),
                        ),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: _attendanceButton(
                          label: "Check Out",
                          icon: Icons.logout,
                          color: Colors.orange,
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

  Widget _attendanceButton({required String label, required IconData icon, required Color color, required VoidCallback onPressed}) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 18),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 5,
      ),
      onPressed: onPressed,
      icon: Icon(icon),
      label: Text(label, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
    );
  }
}