import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/employee.dart';
import '../view_models/attendance_view_model.dart';

class EmployeeSalaryScreen extends StatelessWidget {
  final Employee employee;

  const EmployeeSalaryScreen({super.key, required this.employee});

  @override
  Widget build(BuildContext context) {
    final attendanceVM = Provider.of<AttendanceViewModel>(context);

    // 1. ගණනය කිරීම් (Calculations)
    int totalPresentDays = attendanceVM.attendanceList
        .where((a) => a.employeeNic == employee.nic)
        .length;

    // උදාහරණයක් ලෙස දිනකට ගෙවීම් ගණනය කිරීම (Basic / 30)
    double dailyRate = employee.salary / 30;
    double earnedSalary = dailyRate * totalPresentDays;

    // දීමනා සහ කැපීම් (උදාහරණ ලෙස)
    double allowances = 5000.00;
    double deductions = earnedSalary * 0.08; // EPF 8% වැනි දෙයක්
    double netSalary = (earnedSalary + allowances) - deductions;

    return Scaffold(
      appBar: AppBar(
        title: const Text("My Salary Sheet", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: Colors.indigo,
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header - මාසය සහ මුළු ශුද්ධ වැටුප
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(30),
              decoration: const BoxDecoration(
                color: Colors.indigo,
                borderRadius: BorderRadius.only(bottomLeft: Radius.circular(30), bottomRight: Radius.circular(30)),
              ),
              child: Column(
                children: [
                  const Text("Estimated Net Salary", style: TextStyle(color: Colors.white70, fontSize: 16)),
                  const SizedBox(height: 10),
                  Text("Rs. ${netSalary.toStringAsFixed(2)}",
                      style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 5),
                  const Text("Current Month", style: TextStyle(color: Colors.white60)),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Salary Breakdown", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 15),

                  // විස්තර සහිත Card එක
                  Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    elevation: 3,
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        children: [
                          _salaryRow("Basic Salary", "Rs. ${employee.salary.toStringAsFixed(2)}"),
                          _salaryRow("Days Present", "$totalPresentDays Days"),
                          const Divider(),
                          _salaryRow("Earned (for Days)", "Rs. ${earnedSalary.toStringAsFixed(2)}"),
                          _salaryRow("Allowances (+)", "Rs. ${allowances.toStringAsFixed(2)}", color: Colors.green),
                          _salaryRow("Deductions (-)", "Rs. ${deductions.toStringAsFixed(2)}", color: Colors.red),
                          const Divider(thickness: 2),
                          _salaryRow("Net Salary", "Rs. ${netSalary.toStringAsFixed(2)}", isBold: true),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 25),

                  // උපදෙස් පණිවිඩයක්
                  Container(
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: Colors.blue.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.info_outline, color: Colors.blue),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            "This is a tentative amount based on your attendance records.",
                            style: TextStyle(fontSize: 12, color: Colors.blueGrey),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _salaryRow(String label, String value, {bool isBold = false, Color? color}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontSize: 15, fontWeight: isBold ? FontWeight.bold : FontWeight.normal)),
          Text(value, style: TextStyle(
              fontSize: 15,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              color: color ?? Colors.black87
          )),
        ],
      ),
    );
  }
}