import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/api_service.dart';

class AttendanceHistoryScreen extends StatefulWidget {
  const AttendanceHistoryScreen({super.key});

  @override
  State<AttendanceHistoryScreen> createState() => _AttendanceHistoryScreenState();
}

class _AttendanceHistoryScreenState extends State<AttendanceHistoryScreen> {
  final ApiService _apiService = ApiService();
  bool _isLoading = true;
  List<dynamic> _history = [];

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    try {
      // මෙතනදී කෙලින්ම API එකෙන් attendance data ගන්නවා
      // පසුව මේක ViewModel එකට දාන්න පුළුවන්
      final response = await _apiService.getAttendance();
      setState(() {
        _history = response.reversed.toList(); // අලුත්ම ඒවා උඩට එන්න reversed කරනවා
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Attendance History"),
        backgroundColor: Colors.teal,
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: _loadHistory),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _history.isEmpty
          ? const Center(child: Text("No records found today."))
          : ListView.builder(
        itemCount: _history.length,
        itemBuilder: (context, index) {
          final log = _history[index];
          bool isIn = log['status'] == 'In';

          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: isIn ? Colors.green[100] : Colors.orange[100],
                child: Icon(
                  isIn ? Icons.login : Icons.logout,
                  color: isIn ? Colors.green : Colors.orange,
                ),
              ),
              title: Text(log['employeeName'], style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text("NIC: ${log['employeeNic']}\nDate: ${log['date']}"),
              trailing: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(log['time'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  Text(log['status'], style: TextStyle(color: isIn ? Colors.green : Colors.orange, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}