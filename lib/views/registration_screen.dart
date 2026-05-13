import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/employee.dart';
import '../services/email_service.dart';
import '../view_models/employee_view_model.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _nicController = TextEditingController();
  final _passController = TextEditingController();
  final _confirmPassController = TextEditingController();
  final _otpInputController = TextEditingController();

  bool _isLoading = false;
  bool _otpSent = false;
  String? _generatedOTP;
  Employee? _foundEmployee;

  @override
  void dispose() {
    _nicController.dispose();
    _passController.dispose();
    _confirmPassController.dispose();
    _otpInputController.dispose();
    super.dispose();
  }

  void _handleSendCode() async {
    String nic = _nicController.text.trim();
    String pass = _passController.text.trim();
    String confirmPass = _confirmPassController.text.trim();

    if (nic.isEmpty || pass.isEmpty || confirmPass.isEmpty) {
      _showMsg("Please fill all fields", Colors.orange);
      return;
    }

    if (pass != confirmPass) {
      _showMsg("Passwords do not match!", Colors.red);
      return;
    }

    setState(() => _isLoading = true);
    final viewModel = Provider.of<EmployeeViewModel>(context, listen: false);
    await viewModel.fetchEmployees();

    try {
      _foundEmployee = viewModel.employees.firstWhere((emp) => emp.nic == nic);

      if (_foundEmployee!.isActivated) {
        _showMsg("Account already activated!", Colors.blue);
        setState(() => _isLoading = false);
        return;
      }

      _generatedOTP = EmailService.generateOTP();
      bool success = await EmailService.sendOTP(
          _foundEmployee!.email,
          _foundEmployee!.name,
          _generatedOTP!
      );

      if (success) {
        setState(() => _otpSent = true);
        _showMsg("OTP sent to ${_foundEmployee!.email}", Colors.green);
      }
    } catch (e) {
      _showMsg("NIC not found in our records!", Colors.red);
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _handleCreateAccount() async {
    if (_otpInputController.text.trim() != _generatedOTP) {
      _showMsg("Invalid OTP Code!", Colors.red);
      return;
    }

    setState(() => _isLoading = true);

    final updatedEmp = Employee(
      id: _foundEmployee!.id,
      name: _foundEmployee!.name,
      nic: _foundEmployee!.nic,
      role: _foundEmployee!.role,
      email: _foundEmployee!.email,
      department: _foundEmployee!.department,
      designation: _foundEmployee!.designation,
      salary: _foundEmployee!.salary,
      password: _passController.text.trim(),
      isActivated: true,
    );

    await Provider.of<EmployeeViewModel>(context, listen: false)
        .updateEmployee(_foundEmployee!.id!, updatedEmp);

    if (!mounted) return;

    _showMsg("Account created successfully!", Colors.green);
    Navigator.pop(context);
  }

  void _showMsg(String msg, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(msg), backgroundColor: color)
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Create Account"), backgroundColor: Colors.indigo, foregroundColor: Colors.white),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(25),
        child: Column(
          children: [
            const Icon(Icons.person_add_alt_1, size: 80, color: Colors.indigo),
            const SizedBox(height: 20),

            // NIC, Password Fields
            TextField(controller: _nicController, decoration: const InputDecoration(labelText: "NIC Number", prefixIcon: Icon(Icons.badge))),
            const SizedBox(height: 15),
            TextField(controller: _passController, obscureText: true, decoration: const InputDecoration(labelText: "Password", prefixIcon: Icon(Icons.lock))),
            const SizedBox(height: 15),
            TextField(controller: _confirmPassController, obscureText: true, decoration: const InputDecoration(labelText: "Confirm Password", prefixIcon: Icon(Icons.check_circle))),

            const SizedBox(height: 25),

            if (!_otpSent)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _handleSendCode,
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.indigo, foregroundColor: Colors.white),
                  child: _isLoading ? const CircularProgressIndicator() : const Text("SEND CODE"),
                ),
              ),

            if (_otpSent) ...[
              const Divider(height: 40),
              const Text("Enter the 4-digit code sent to your email", style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 15),
              TextField(
                controller: _otpInputController,
                textAlign: TextAlign.center,
                keyboardType: TextInputType.number,
                style: const TextStyle(fontSize: 24, letterSpacing: 10),
                decoration: const InputDecoration(hintText: "0000", border: OutlineInputBorder()),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _handleCreateAccount,
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white),
                  child: const Text("CREATE ACCOUNT"),
                ),
              ),
            ]
          ],
        ),
      ),
    );
  }
}