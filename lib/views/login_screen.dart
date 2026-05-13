import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_employee_manager/views/admin_dashboard.dart';
import '../view_models/employee_view_model.dart';
import 'employee_dashboard.dart';
import 'registration_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _nicController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoggingIn = false;
  bool _obscureText = true;

  void _handleLogin() async {
    String nic = _nicController.text.trim();
    String password = _passwordController.text.trim();

    if (nic.isEmpty || password.isEmpty) {
      _showSnackBar("Please enter both NIC and Password", Colors.orange);
      return;
    }

    setState(() => _isLoggingIn = true);
    final viewModel = Provider.of<EmployeeViewModel>(context, listen: false);

    await viewModel.fetchEmployees();

    try {
      final employee = viewModel.employees.firstWhere(
            (emp) => emp.nic == nic,
      );

      if (!employee.isActivated) {
        _showSnackBar("Account not activated. Please use 'Create One'.", Colors.blue);
        setState(() => _isLoggingIn = false);
        return;
      }

      if (employee.password == password) {
        if (employee.role == 'Admin') {
          _goTo(const AdminDashboard());
        } else {
          _goTo(EmployeeDashboard(employee: employee));
        }
      } else {
        _showSnackBar("Incorrect Password!", Colors.red);
      }
    } catch (e) {
      _showSnackBar("User not found! Please register first.", Colors.red);
    } finally {
      setState(() => _isLoggingIn = false);
    }
  }

  void _goTo(Widget screen) {
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => screen));
  }

  void _showSnackBar(String msg, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg),
      backgroundColor: color,
      behavior: SnackBarBehavior.floating,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.lock_outline_rounded, size: 100, color: Colors.indigo),
              const SizedBox(height: 15),
              const Text(
                "Smart HR Login",
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.indigo),
              ),
              const SizedBox(height: 40),

              TextField(
                controller: _nicController,
                decoration: InputDecoration(
                  labelText: "NIC Number",
                  prefixIcon: const Icon(Icons.person_outline),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                ),
              ),
              const SizedBox(height: 20),

              TextField(
                controller: _passwordController,
                obscureText: _obscureText,
                decoration: InputDecoration(
                  labelText: "Password",
                  prefixIcon: const Icon(Icons.lock_open_outlined),
                  suffixIcon: IconButton(
                    icon: Icon(_obscureText ? Icons.visibility_off : Icons.visibility),
                    onPressed: () {
                      setState(() => _obscureText = !_obscureText);
                    },
                  ),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                ),
              ),
              const SizedBox(height: 30),

              // Login Button
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.indigo,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  ),
                  onPressed: _isLoggingIn ? null : _handleLogin,
                  child: _isLoggingIn
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text("LOGIN", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                ),
              ),

              const SizedBox(height: 25),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Don't have an account? "),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => const RegistrationScreen()));
                    },
                    child: const Text(
                      "Create One",
                      style: TextStyle(color: Colors.indigo, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}