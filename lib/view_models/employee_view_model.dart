import 'package:flutter/material.dart';
import '../models/employee.dart';

class EmployeeViewModel extends ChangeNotifier {
  List<Employee> _employees = [];
  bool _isLoading = false;

  List<Employee> get employees => _employees;
  bool get isLoading => _isLoading;

  // Danata meka empty thiyamu, error nathuwa inna
  void fetchEmployees() {
    notifyListeners();
  }
}