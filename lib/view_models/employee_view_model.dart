import 'package:flutter/material.dart';
import '../models/employee.dart';
import '../services/api_service.dart';

class EmployeeViewModel extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  List<Employee> _employees = [];
  bool _isLoading = false;

  List<Employee> get employees => _employees;
  bool get isLoading => _isLoading;

  // --- API Methods ---

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

  // --- Payroll Calculation Logic (Sri Lankan Standards) ---

  // Sevekayaage vatupen 8% k EPF valata adu wenava
  double calculateEmployeeEPF(double basicSalary) {
    return basicSalary * 0.08;
  }

  // Ayathanaya (Company) visin 12% k EPF valata saha 3% k ETF valata gewanava
  double calculateCompanyContribution(double basicSalary) {
    return basicSalary * 0.15; // 12% + 3%
  }

  // Sevekayaata athata labena vatupa (Net Salary)
  double calculateNetSalary(double basicSalary) {
    return basicSalary - calculateEmployeeEPF(basicSalary);
  }

  // Dashboard ekata ona wena Total Salary Cost eka (Okkoma employeeslata yana wiyadama)
  double getTotalPayrollCost() {
    return _employees.fold(0, (sum, emp) => sum + emp.salary);
  }
}