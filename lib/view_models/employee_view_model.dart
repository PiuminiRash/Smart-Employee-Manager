import 'package:flutter/material.dart';
import '../models/employee.dart';
import '../services/api_service.dart';

class EmployeeViewModel extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  List<Employee> _employees = [];
  bool _isLoading = false;

  List<Employee> get employees => _employees;
  bool get isLoading => _isLoading;

  Future<void> fetchEmployees() async {
    _isLoading = true;
    notifyListeners();
    try {
      _employees = await _apiService.getEmployees();
    } catch (e) {
      debugPrint("Error fetching: ${e.toString()}");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addEmployee(Employee employee) async {
    _isLoading = true;
    notifyListeners();
    try {
      bool success = await _apiService.addEmployee(employee);
      if (success) await fetchEmployees();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deleteEmployee(String id) async {
    bool success = await _apiService.deleteEmployee(id);
    if (success) {
      _employees.removeWhere((emp) => emp.id == id);
      notifyListeners();
    }
  }

  Future<void> updateEmployee(String id, Employee employee) async {
    bool success = await _apiService.updateEmployee(id, employee);
    if (success) {
      await fetchEmployees();
    }
  }

  double calculateEmployeeEPF(double basicSalary) {
    return basicSalary * 0.08;
  }

  double calculateCompanyContribution(double basicSalary) {
    return basicSalary * 0.15; // 12% + 3%
  }

  double calculateNetSalary(double basicSalary) {
    return basicSalary - calculateEmployeeEPF(basicSalary);
  }

  double getTotalPayrollCost() {
    return _employees.fold(0, (sum, emp) => sum + emp.salary);
  }
}