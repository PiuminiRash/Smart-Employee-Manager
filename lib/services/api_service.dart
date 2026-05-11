import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/employee.dart';

class ApiService {
  // Oyaage MockAPI link eka methanata danna
  static const String baseUrl = 'https://6a021ba70d92f63dd2535650.mockapi.io/employeemanager/employee';

  // 1. READ (Get all employees)
  Future<List<Employee>> getEmployees() async {
    final response = await http.get(Uri.parse(baseUrl));
    if (response.statusCode == 200) {
      List data = json.decode(response.body);
      return data.map((item) => Employee.fromJson(item)).toList();
    } else {
      throw Exception('Data load kireema failed!');
    }
  }

  // 2. CREATE (Add new employee)
  Future<bool> addEmployee(Employee employee) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(employee.toJson()),
    );
    return response.statusCode == 201;
  }

  // 3. UPDATE (Edit employee)
  Future<bool> updateEmployee(String id, Employee employee) async {
    final response = await http.put(
      Uri.parse('$baseUrl/$id'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(employee.toJson()),
    );
    return response.statusCode == 200;
  }

  // 4. DELETE (Remove employee)
  Future<bool> deleteEmployee(String id) async {
    final response = await http.delete(Uri.parse('$baseUrl/$id'));
    return response.statusCode == 200;
  }
}