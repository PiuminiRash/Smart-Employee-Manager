import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AdminAttendanceHistoryScreen extends StatefulWidget {
  const AdminAttendanceHistoryScreen({super.key});

  @override
  State<AdminAttendanceHistoryScreen> createState() => _AdminAttendanceHistoryScreenState();
}

class _AdminAttendanceHistoryScreenState extends State<AdminAttendanceHistoryScreen> {
  String _searchQuery = "";
  DateTime? _selectedDate;

  // පරීක්ෂා කිරීම සඳහා Dummy දත්ත (පසුව මෙය ViewModel එකට සම්බන්ධ කරන්න)
  final List<Map<String, dynamic>> _attendanceData = [
    {"name": "Kamal Perera", "nic": "199512345678", "dept": "IT", "role": "Developer", "date": "2026-05-13", "time": "08:30 AM", "status": "Present"},
    {"name": "Nimal Siri", "nic": "199087654321", "dept": "HR", "role": "Manager", "date": "2026-05-13", "time": "08:45 AM", "status": "Present"},
    {"name": "Sunil Shantha", "nic": "198855667788", "dept": "Finance", "role": "Accountant", "date": "2026-05-12", "time": "09:00 AM", "status": "Late"},
  ];

  @override
  Widget build(BuildContext context) {
    // Filtering Logic: නම, NIC, Dept, Role සහ Date අනුව පෙරා වෙන් කිරීම
    final filteredLogs = _attendanceData.where((log) {
      final query = _searchQuery.toLowerCase();
      final matchesQuery = log['name'].toLowerCase().contains(query) ||
          log['nic'].toLowerCase().contains(query) ||
          log['dept'].toLowerCase().contains(query) ||
          log['role'].toLowerCase().contains(query);

      bool matchesDate = true;
      if (_selectedDate != null) {
        matchesDate = log['date'] == DateFormat('yyyy-MM-dd').format(_selectedDate!);
      }

      return matchesQuery && matchesDate;
    }).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FA),
      appBar: AppBar(
        title: const Text("Staff Attendance", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: Colors.brown,
        centerTitle: true,
      ),
      body: Column(
        children: [
          // --- Search & Date Picker Section ---
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.white,
            child: Column(
              children: [
                TextField(
                  onChanged: (value) => setState(() => _searchQuery = value),
                  decoration: InputDecoration(
                    hintText: "Search Name, NIC, Dept or Role...",
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    contentPadding: const EdgeInsets.symmetric(vertical: 0),
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: _pickDate,
                        icon: const Icon(Icons.calendar_today, size: 18),
                        label: Text(_selectedDate == null
                            ? "Filter by Date"
                            : DateFormat('yyyy-MM-dd').format(_selectedDate!)),
                      ),
                    ),
                    if (_selectedDate != null)
                      IconButton(
                        icon: const Icon(Icons.clear, color: Colors.red),
                        onPressed: () => setState(() => _selectedDate = null),
                      ),
                  ],
                ),
              ],
            ),
          ),

          // --- Attendance List ---
          Expanded(
            child: filteredLogs.isEmpty
                ? const Center(child: Text("No attendance records found."))
                : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: filteredLogs.length,
              itemBuilder: (context, index) {
                final log = filteredLogs[index];
                return Card(
                  elevation: 2,
                  margin: const EdgeInsets.only(bottom: 10),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.brown.withValues(alpha: 0.1),
                      child: const Icon(Icons.person, color: Colors.brown),
                    ),
                    title: Text(log['name'], style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("${log['role']} • ${log['dept']}"),
                        Text("Date: ${log['date']} | Time: ${log['time']}", style: const TextStyle(fontSize: 12)),
                      ],
                    ),
                    trailing: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: log['status'] == "Present" ? Colors.green.withValues(alpha: 0.1) : Colors.orange.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(log['status'],
                          style: TextStyle(color: log['status'] == "Present" ? Colors.green : Colors.orange, fontWeight: FontWeight.bold, fontSize: 12)),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _pickDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2024),
      lastDate: DateTime.now(),
    );
    if (picked != null) setState(() => _selectedDate = picked);
  }
}