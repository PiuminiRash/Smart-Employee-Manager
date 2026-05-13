class Employee {
  final String? id;
  final String name;
  final String nic;
  final String role;
  final String email;
  final String department;
  final String designation;
  final double salary;
  final String password;
  final bool isActivated;

  Employee({
    this.id,
    required this.name,
    required this.nic,
    required this.role,
    required this.email,
    required this.department,
    required this.designation,
    required this.salary,
    this.password = "",
    this.isActivated = false,
  });

  factory Employee.fromJson(Map<String, dynamic> json) {
    return Employee(
      id: json['id'],
      name: json['name'] ?? '',
      nic: json['nic'] ?? '',
      role: json['role'] ?? 'Employee',
      email: json['email'] ?? '',
      department: json['department'] ?? '',
      designation: json['designation'] ?? '',
      salary: double.tryParse(json['salary'].toString()) ?? 0.0,
      password: json['password'] ?? '',
      isActivated: json['isActivated'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'nic': nic,
      'role': role,
      'email': email,
      'department': department,
      'designation': designation,
      'salary': salary,
      'password': password,
      'isActivated': isActivated,
    };
  }
}