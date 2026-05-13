import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../view_models/employee_view_model.dart';
import 'home_screen.dart';
import 'add_employee_screen.dart';
import 'admin_attendance_history_screen.dart';
import 'login_screen.dart';

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final employeeVM = context.watch<EmployeeViewModel>();

    int totalEmployees = employeeVM.employees.length;
    double totalPayroll = employeeVM.getTotalPayrollCost();

    return Scaffold(
      backgroundColor: const Color(0xFFF0F2F5),
      appBar: AppBar(
        title: const Text("Admin Panel", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (c) => const LoginScreen())),
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Company Overview", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 15),

            Row(
              children: [
                _buildStatCard("Total Employees", totalEmployees.toString(), Icons.people, Colors.blue),
                const SizedBox(width: 15),
                _buildStatCard("Active Leaves", "03", Icons.event_busy, Colors.orange),
              ],
            ),
            const SizedBox(height: 15),
            _buildLargeStatCard("Total Monthly Payroll", "Rs. ${totalPayroll.toStringAsFixed(2)}", Icons.payments, Colors.green),

            const SizedBox(height: 30),
            const Text("Management Actions", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 15),

            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 15,
              mainAxisSpacing: 15,
              children: [
                _buildAdminAction(context, "Manage Employees", Icons.badge, Colors.indigo, const HomeScreen()),
                _buildAdminAction(context, "Add New Employee", Icons.person_add_alt_1, Colors.teal, const AddEmployeeScreen()),
                _buildAdminAction(context, "Attendance Logs", Icons.assignment, Colors.brown, const AttendanceHistoryScreen()),
                _buildAdminAction(context, "Leave Requests", Icons.approval, Colors.deepOrange, null), // මීළඟට මෙය හදමු
              ],
            ),
          ],
        ),
      ),
    );
  }

  // කුඩා Stat Card එකක්
  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10)],
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 30),
            const SizedBox(height: 10),
            Text(title, style: const TextStyle(color: Colors.grey, fontSize: 13)),
            Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  // ලොකු Payroll Card එකක්
  Widget _buildLargeStatCard(String title, String value, IconData icon, Color color) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [color, color.withValues(alpha: 0.7)]),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          CircleAvatar(backgroundColor: Colors.white24, radius: 25, child: Icon(icon, color: Colors.white)),
          const SizedBox(width: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(color: Colors.white70, fontSize: 14)),
              Text(value, style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
            ],
          )
        ],
      ),
    );
  }

  // Action Button එකක්
  Widget _buildAdminAction(BuildContext context, String title, IconData icon, Color color, Widget? target) {
    return InkWell(
      onTap: () {
        if (target != null) Navigator.push(context, MaterialPageRoute(builder: (c) => target));
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 5)],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 40),
            const SizedBox(height: 10),
            Text(title, textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
          ],
        ),
      ),
    );
  }
}