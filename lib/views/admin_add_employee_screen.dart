import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/employee.dart';
import '../view_models/employee_view_model.dart';
import '../utils/app_constants.dart';

class AddEmployeeScreen extends StatefulWidget {
  final Employee? employee;

  const AddEmployeeScreen({super.key, this.employee});

  @override
  State<AddEmployeeScreen> createState() => _AddEmployeeScreenState();
}

class _AddEmployeeScreenState extends State<AddEmployeeScreen> {
  late TextEditingController _nameController;
  late TextEditingController _nicController;
  late TextEditingController _emailController;
  late TextEditingController _salaryController;

  String? _selectedDept;
  String? _selectedDesignation;
  String _selectedRole = "Employee"; // Default Role

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.employee?.name ?? '');
    _nicController = TextEditingController(text: widget.employee?.nic ?? '');
    _emailController = TextEditingController(text: widget.employee?.email ?? '');
    _salaryController = TextEditingController(text: widget.employee?.salary.toString() ?? '');

    if (widget.employee != null) {
      _selectedDept = widget.employee!.department;
      _selectedDesignation = widget.employee!.designation;
      _selectedRole = widget.employee!.role;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _nicController.dispose();
    _emailController.dispose();
    _salaryController.dispose();
    super.dispose();
  }

  bool isValidNIC(String nic) {
    RegExp oldNIC = RegExp(r'^[0-9]{9}[vVxX]$');
    RegExp newNIC = RegExp(r'^[0-9]{12}$');
    return oldNIC.hasMatch(nic) || newNIC.hasMatch(nic);
  }

  bool isValidEmail(String email) {
    return RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(email);
  }

  @override
  Widget build(BuildContext context) {
    bool isEdit = widget.employee != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? 'Update Profile' : 'Register New Member'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // 1. Full Name
            _buildTextField(_nameController, 'Full Name', Icons.person),
            const SizedBox(height: 15),

            // 2. NIC Number
            _buildTextField(_nicController, 'NIC Number', Icons.badge, hint: '95xxxxxxxV'),
            const SizedBox(height: 15),

            // 3. Role (NIC එකට පස්සේ)
            DropdownButtonFormField<String>(
              value: _selectedRole,
              decoration: _inputDecoration('Access Level (Role)', Icons.security),
              items: ["Employee", "Admin"].map((role) {
                return DropdownMenuItem(value: role, child: Text(role));
              }).toList(),
              onChanged: (value) => setState(() => _selectedRole = value!),
            ),
            const SizedBox(height: 15),

            // 4. Email Address
            _buildTextField(_emailController, 'Email Address', Icons.email, hint: 'example@mail.com'),
            const SizedBox(height: 15),

            // 5. Department
            DropdownButtonFormField<String>(
              value: _selectedDept,
              decoration: _inputDecoration('Department', Icons.business),
              items: AppConstants.departments.keys.map((dept) {
                return DropdownMenuItem(value: dept, child: Text(dept));
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedDept = value;
                  _selectedDesignation = null;
                });
              },
            ),
            const SizedBox(height: 15),

            // 6. Designation
            DropdownButtonFormField<String>(
              value: _selectedDesignation,
              decoration: _inputDecoration('Designation', Icons.work),
              items: _selectedDept == null
                  ? []
                  : AppConstants.departments[_selectedDept]!.map((des) {
                return DropdownMenuItem(value: des, child: Text(des));
              }).toList(),
              onChanged: (value) => setState(() => _selectedDesignation = value),
              hint: const Text("Select Designation"),
            ),
            const SizedBox(height: 15),

            // 7. Salary
            _buildTextField(_salaryController, 'Basic Salary (LKR)', Icons.payments, isNumber: true),
            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.indigo,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))
                ),
                onPressed: _saveData,
                child: Text(isEdit ? 'Save Changes' : 'Confirm Registration',
                    style: const TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            )
          ],
        ),
      ),
    );
  }

  void _saveData() async {
    String nic = _nicController.text.trim();
    String email = _emailController.text.trim();

    if (_nameController.text.isEmpty || nic.isEmpty || email.isEmpty || _selectedDept == null || _selectedDesignation == null) {
      _showSnackBar('Please fill all required fields', Colors.orange);
      return;
    }

    if (!isValidNIC(nic)) {
      _showSnackBar('Invalid NIC format!', Colors.red);
      return;
    }

    if (!isValidEmail(email)) {
      _showSnackBar('Please enter a valid email address!', Colors.red);
      return;
    }

    final empData = Employee(
      id: widget.employee?.id,
      name: _nameController.text.trim(),
      nic: nic,
      role: _selectedRole,
      email: email,
      department: _selectedDept!,
      designation: _selectedDesignation!,
      salary: double.tryParse(_salaryController.text) ?? 0.0,
      isActivated: widget.employee?.isActivated ?? false,
      password: widget.employee?.password ?? "",
    );

    final viewModel = Provider.of<EmployeeViewModel>(context, listen: false);

    if (widget.employee != null) {
      await viewModel.updateEmployee(widget.employee!.id!, empData);
      _showSnackBar('Profile updated successfully!', Colors.green);
    } else {
      await viewModel.addEmployee(empData);
      _showSnackBar('Member registered! Activation required.', Colors.green);
    }

    if (mounted) Navigator.pop(context);
  }

  Widget _buildTextField(TextEditingController controller, String label, IconData icon, {bool isNumber = false, String? hint}) {
    return TextField(
      controller: controller,
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      decoration: _inputDecoration(label, icon).copyWith(hintText: hint),
    );
  }

  InputDecoration _inputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, color: Colors.indigo),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.withAlpha(50)),
      ),
    );
  }

  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message), backgroundColor: color));
  }
}