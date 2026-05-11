class Employee {
  final String? id;
  final String nic;
  final String name;
  final String department;
  final String designation;
  final double salary; // Salary එක double එකක් විදියට ගන්නවා

  Employee({
    this.id,
    required this.nic,
    required this.name,
    required this.department,
    required this.designation,
    required this.salary,
  });

  factory Employee.fromJson(Map<String, dynamic> json) {
    return Employee(
      id: json['id'],
      nic: json['nic'] ?? '',
      name: json['name'] ?? '',
      department: json['department'] ?? '',
      designation: json['designation'] ?? '',
      // String එකක් විදියට ආවොත් double වලට convert කරනවා
      salary: double.tryParse(json['salary'].toString()) ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nic': nic,
      'name': name,
      'department': department,
      'designation': designation,
      'salary': salary,
    };
  }
}