import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../view_models/employee_view_model.dart';
import 'home_screen.dart';
import 'add_employee_screen.dart';
import 'attendance_screen.dart';
import 'attendance_history_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<EmployeeViewModel>();

    int totalEmployees = viewModel.employees.length;
    double totalPayroll = viewModel.getTotalPayrollCost();
    double avgSalary = totalEmployees > 0 ? totalPayroll / totalEmployees : 0.0;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Admin Dashboard',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: Colors.blueAccent,
        elevation: 0,
        centerTitle: true,
      ),
      body: RefreshIndicator(
        // 'onPressed' වෙනුවට මෙතන 'onRefresh' විය යුතුයි
        onRefresh: () async {
          await viewModel.fetchEmployees();
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Company Overview",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),

              Row(
                children: [
                  _buildSummaryCard(
                      "Total Staff",
                      totalEmployees.toString(),
                      Icons.people,
                      Colors.blue
                  ),
                  _buildSummaryCard(
                      "Avg. Salary",
                      "Rs.${(avgSalary / 1000).toStringAsFixed(1)}k",
                      Icons.analytics,
                      Colors.orange
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _buildLargeSummaryCard(
                  "Total Monthly Payroll",
                  "Rs. ${totalPayroll.toStringAsFixed(2)}",
                  Icons.account_balance_wallet,
                  Colors.green
              ),

              const SizedBox(height: 30),
              const Text(
                "Quick Actions",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),

              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                children: [
                  _buildActionButton(context, "Employee List", Icons.list_alt,
                      Colors.purple, const HomeScreen()),
                  _buildActionButton(context, "Add Employee", Icons.person_add,
                      Colors.indigo, const AddEmployeeScreen()),
                  _buildActionButton(context, "Mark Attendance", Icons.fact_check,
                      Colors.teal, const AttendanceScreen()),
                  _buildActionButton(context, "Attendance Log", Icons.history,
                      Colors.brown, const AttendanceHistoryScreen()),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryCard(String title, String value, IconData icon, Color color) {
    return Expanded(
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Icon(icon, size: 30, color: color),
              const SizedBox(height: 8),
              Text(title, style: const TextStyle(color: Colors.grey, fontSize: 13)),
              FittedBox(
                child: Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLargeSummaryCard(String title, String value, IconData icon, Color color) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        // withValues භාවිතා කරමින් deprecated warning එක ඉවත් කිරීම
        gradient: LinearGradient(colors: [color, color.withValues(alpha: 0.8)]),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [BoxShadow(color: color.withValues(alpha: 0.3), blurRadius: 8, offset: const Offset(0, 4))],
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: Colors.white.withValues(alpha: 0.2),
            radius: 30,
            child: Icon(icon, size: 30, color: Colors.white),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(color: Colors.white70, fontSize: 14)),
                FittedBox(
                  child: Text(value, style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildActionButton(BuildContext context, String title, IconData icon, Color color, Widget screen) {
    return InkWell(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => screen));
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, spreadRadius: 1)],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              backgroundColor: color.withValues(alpha: 0.1),
              radius: 25,
              child: Icon(icon, color: color, size: 28),
            ),
            const SizedBox(height: 10),
            Text(title,
                textAlign: TextAlign.center,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.black87)),
          ],
        ),
      ),
    );
  }
}