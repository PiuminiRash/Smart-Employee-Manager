import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/employee.dart';

class ApiService {
  // Oyaage MockAPI endpoint URL eka methanata paste karanna
  static const String baseUrl = 'https://663f2552e3a73321.mockapi.io/employees';

  // 1. Get All Employees
  Future<List<Employee>> getEmployees() async {
    final response = await http.get(Uri.parse(baseUrl));
    if (response.statusCode == 200) {
      List data = json.decode(response.body);
      return data.map((item) => Employee.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load employees');
    }
  }

  // 2. Add New Employee
  Future<bool> addEmployee(Employee employee) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(employee.toJson()),
    );
    return response.statusCode == 201;
  }
}