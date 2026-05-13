import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/employee.dart';
import 'package:flutter/foundation.dart';

class ApiService {
  static const String baseUrl = 'https://6a021ba70d92f63dd2535650.mockapi.io/employeemanager';

  Future<List<Employee>> getEmployees() async {
    final response = await http.get(Uri.parse('$baseUrl/employee'));
    if (response.statusCode == 200) {
      List data = json.decode(response.body);
      return data.map((item) => Employee.fromJson(item)).toList();
    } else {
      throw Exception('Data load kireema failed!');
    }
  }

  Future<bool> addEmployee(Employee employee) async {
    final response = await http.post(
      Uri.parse('$baseUrl/employee'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(employee.toJson()),
    );
    return response.statusCode == 201;
  }

  Future<bool> updateEmployee(String id, Employee employee) async {
    final response = await http.put(
      Uri.parse('$baseUrl/employee/$id'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(employee.toJson()),
    );
    return response.statusCode == 200;
  }

  Future<bool> deleteEmployee(String id) async {
    final response = await http.delete(Uri.parse('$baseUrl/employee/$id'));
    return response.statusCode == 200;
  }

  Future<bool> markAttendance(Map<String, dynamic> attendanceData) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/attendance'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(attendanceData),
      );
      return response.statusCode == 201;
    } catch (e) {
      debugPrint("Attendance API Error: $e");
      return false;
    }
  }

  Future<List<dynamic>> getAttendance() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/attendance'));
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
      return [];
    } catch (e) {
      debugPrint("Fetch Attendance Error: $e");
      return [];
    }
  }
}