class Employee {
  final String? id;
  final String name;
  final String department;
  final String designation;

  Employee({this.id, required this.name, required this.department, required this.designation});

  factory Employee.fromJson(Map<String, dynamic> json) {
    return Employee(
      id: json['id'],
      name: json['name'],
      department: json['department'],
      designation: json['designation'] ?? 'Staff',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'department': department,
      'designation': designation,
    };
  }
}