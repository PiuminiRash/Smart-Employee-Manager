import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/employee.dart';
import '../view_models/employee_view_model.dart';

class EmployeeDetailsScreen extends StatelessWidget {
  final Employee employee;

  const EmployeeDetailsScreen({super.key, required this.employee});

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<EmployeeViewModel>(context, listen: false);

    // Calculations
    double netSalary = viewModel.calculateNetSalary(employee.salary);
    double epf8 = viewModel.calculateEmployeeEPF(employee.salary);
    double companyContribution = viewModel.calculateCompanyContribution(employee.salary);

    return Scaffold(
      appBar: AppBar(
        title: Text('${employee.name}\'s Profile'),
        backgroundColor: Colors.blueAccent,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: CircleAvatar(
                radius: 50,
                backgroundColor: Colors.blueAccent,
                child: Icon(Icons.person, size: 50, color: Colors.white),
              ),
            ),
            const SizedBox(height: 20),
            _infoCard("Personal Information", [
              _infoTile(Icons.badge, "NIC", employee.nic),
              _infoTile(Icons.business, "Department", employee.department),
              _infoTile(Icons.work, "Designation", employee.designation),
            ]),
            const SizedBox(height: 20),
            _infoCard("Payroll & Benefits (Monthly)", [
              _infoTile(Icons.payments, "Basic Salary", "Rs. ${employee.salary.toStringAsFixed(2)}"),
              _infoTile(Icons.arrow_downward, "EPF Deduction (8%)", "Rs. ${epf8.toStringAsFixed(2)}", color: Colors.red),
              _infoTile(Icons.account_balance_wallet, "Net Salary", "Rs. ${netSalary.toStringAsFixed(2)}", color: Colors.green, isBold: true),
              const Divider(),
              _infoTile(Icons.apartment, "Company EPF/ETF (15%)", "Rs. ${companyContribution.toStringAsFixed(2)}"),
            ]),
          ],
        ),
      ),
    );
  }

  Widget _infoCard(String title, List<Widget> children) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blueAccent)),
            const Divider(),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _infoTile(IconData icon, String label, String value, {Color? color, bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey),
          const SizedBox(width: 10),
          Text("$label: ", style: const TextStyle(fontWeight: FontWeight.w500)),
          Expanded(
            child: Text(value,
                textAlign: TextAlign.end,
                style: TextStyle(
                    color: color ?? Colors.black,
                    fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
                    fontSize: isBold ? 16 : 14
                )
            ),
          ),
        ],
      ),
    );
  }
}