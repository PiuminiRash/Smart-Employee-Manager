import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/employee.dart';
import '../view_models/employee_view_model.dart';

class AddEmployeeScreen extends StatefulWidget {
  final Employee? employee;

  const AddEmployeeScreen({super.key, this.employee});

  @override
  State<AddEmployeeScreen> createState() => _AddEmployeeScreenState();
}

class _AddEmployeeScreenState extends State<AddEmployeeScreen> {
  late TextEditingController _nameController;
  late TextEditingController _deptController;
  late TextEditingController _designationController;
  late TextEditingController _nicController;     // Aluth
  late TextEditingController _salaryController;  // Aluth

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.employee?.name ?? '');
    _deptController = TextEditingController(text: widget.employee?.department ?? '');
    _designationController = TextEditingController(text: widget.employee?.designation ?? '');
    _nicController = TextEditingController(text: widget.employee?.nic ?? '');
    _salaryController = TextEditingController(text: widget.employee?.salary.toString() ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _deptController.dispose();
    _designationController.dispose();
    _nicController.dispose();
    _salaryController.dispose();
    super.dispose();
  }

  // NIC Validation Logic
  bool isValidNIC(String nic) {
    RegExp oldNIC = RegExp(r'^[0-9]{9}[vVxX]$'); // 9 digits + V/X
    RegExp newNIC = RegExp(r'^[0-9]{12}$');      // 12 digits
    return oldNIC.hasMatch(nic) || newNIC.hasMatch(nic);
  }

  @override
  Widget build(BuildContext context) {
    bool isEdit = widget.employee != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? 'Edit Employee Profile' : 'Register New Employee'),
        backgroundColor: Colors.blueAccent,
      ),
      body: SingleChildScrollView( // Keyboard eka enakota scroll wenna
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Full Name', prefixIcon: Icon(Icons.person)),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _nicController,
              decoration: const InputDecoration(
                labelText: 'NIC Number',
                hintText: 'e.g. 951234567V or 199512345678',
                prefixIcon: Icon(Icons.badge),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _deptController,
              decoration: const InputDecoration(labelText: 'Department', prefixIcon: Icon(Icons.business)),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _designationController,
              decoration: const InputDecoration(labelText: 'Designation', prefixIcon: Icon(Icons.work)),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _salaryController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Basic Salary (LKR)',
                prefixIcon: Icon(Icons.money),
                prefixText: 'Rs. ',
              ),
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.blueAccent),
                onPressed: () async {
                  String nic = _nicController.text.trim();

                  // Validation Check
                  if (_nameController.text.isEmpty || nic.isEmpty || _salaryController.text.isEmpty) {
                    _showSnackBar('Please fill all required fields', Colors.orange);
                    return;
                  }

                  if (!isValidNIC(nic)) {
                    _showSnackBar('Invalid NIC format!', Colors.red);
                    return;
                  }

                  final empData = Employee(
                    id: widget.employee?.id,
                    nic: nic,
                    name: _nameController.text,
                    department: _deptController.text,
                    designation: _designationController.text,
                    salary: double.tryParse(_salaryController.text) ?? 0.0,
                  );

                  final viewModel = Provider.of<EmployeeViewModel>(context, listen: false);

                  if (isEdit) {
                    await viewModel.updateEmployee(widget.employee!.id!, empData);
                    _showSnackBar('Employee updated successfully', Colors.green);
                  } else {
                    await viewModel.addEmployee(empData);
                    _showSnackBar('Employee added successfully', Colors.green);
                  }

                  if (!context.mounted) return;
                  Navigator.pop(context);
                },
                child: Text(isEdit ? 'Update Profile' : 'Save Employee',
                    style: const TextStyle(fontSize: 18, color: Colors.white)),
              ),
            )
          ],
        ),
      ),
    );
  }

  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: color),
    );
  }
}