import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../view_models/employee_view_model.dart';
import 'add_employee_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // App eka open weddima data fetch karanna
    Future.microtask(() =>
        Provider.of<EmployeeViewModel>(context, listen: false).fetchEmployees());
  }

  @override
  Widget build(BuildContext context) {
    // ViewModel eka kiyawanna
    final viewModel = context.watch<EmployeeViewModel>();

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Smart Employee Manager',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: Colors.blueAccent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: () => viewModel.fetchEmployees(),
          ),
        ],
      ),
      body: viewModel.isLoading
          ? const Center(child: CircularProgressIndicator())
          : viewModel.employees.isEmpty
          ? const Center(
          child: Text('No Employees Found.\nClick + to add one!',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.grey)))
          : ListView.builder(
        padding: const EdgeInsets.all(10),
        itemCount: viewModel.employees.length,
        itemBuilder: (context, index) {
          final employee = viewModel.employees[index];
          return Card(
            elevation: 3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              onTap: () {
                // Update/Edit feature: Card eka click kalama Edit screen ekata yanawa
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddEmployeeScreen(employee: employee),
                  ),
                );
              },
              leading: CircleAvatar(
                // Error fix: withValues pavichchi kala
                backgroundColor: Colors.blueAccent.withValues(alpha: 0.1),
                child: Text(employee.name[0].toUpperCase(),
                    style: const TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.bold)),
              ),
              title: Text(employee.name,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 4),
                  Text(employee.designation, style: const TextStyle(color: Colors.black87)),
                  Text(employee.department, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                ],
              ),
              trailing: IconButton(
                icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                onPressed: () {
                  _showDeleteDialog(context, viewModel, employee.id!);
                },
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blueAccent,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddEmployeeScreen()),
          );
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, EmployeeViewModel viewModel, String id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Delete'),
        content: const Text('Are you sure you want to remove this employee?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          TextButton(
            onPressed: () async {
              await viewModel.deleteEmployee(id);
              if (context.mounted) Navigator.pop(context);
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}