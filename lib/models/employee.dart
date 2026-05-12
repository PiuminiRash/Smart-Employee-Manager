class Employee {
  final String? id;
  final String name;
  final String nic;
  final String role;         // 'Admin' හෝ 'Employee'
  final String email;        // Activation OTP එක යැවීමට
  final String department;
  final String designation;
  final double salary;
  final String password;     // Login වීම සඳහා (මුලින් හිස්ව පවතී)
  final bool isActivated;    // Account එක සක්‍රීය කර ඇත්දැයි බැලීමට

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

  // JSON වලින් Data ලබා ගැනීම (API එකෙන් එන දත්ත)
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

  // API එකට Data යැවීම (Create/Update සඳහා)
  // මෙතනදීත් ඔයාගේ UI එකේ පිළිවෙලටම Keys සකස් කර තියෙනවා
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