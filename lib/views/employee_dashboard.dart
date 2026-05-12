import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/employee.dart';

class LeaveRequestScreen extends StatefulWidget {
  final Employee employee;

  const LeaveRequestScreen({super.key, required this.employee});

  @override
  State<LeaveRequestScreen> createState() => _LeaveRequestScreenState();
}

class _LeaveRequestScreenState extends State<LeaveRequestScreen> {
  final _formKey = GlobalKey<FormState>();
  String _selectedLeaveType = 'Annual Leave';
  DateTime _selectedDate = DateTime.now();
  final TextEditingController _reasonController = TextEditingController();

  final List<String> _leaveTypes = ['Annual Leave', 'Sick Leave', 'Casual Leave', 'Short Leave'];

  // --- පරීක්ෂා කිරීම සඳහා Dummy Data ---
  // පසුකාලීනව මේවා Database හෝ ViewModel එකෙන් ලබාගන්නා ලෙස සකස් කළ හැක.
  final List<Map<String, dynamic>> _myLeaves = [
    {"date": "2026-05-20", "type": "Sick Leave", "status": "Approved", "color": Colors.green},
    {"date": "2026-05-25", "type": "Annual Leave", "status": "Pending", "color": Colors.orange},
    {"date": "2026-05-10", "type": "Casual Leave", "status": "Rejected", "color": Colors.red},
  ];

  void _submitLeave() {
    if (_formKey.currentState!.validate()) {
      // මෙතනදී නිවාඩු ඉල්ලීම Database එකට යැවීමේ logic එක පසුව එක් කළ හැක.
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Leave request submitted successfully!"),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.purple,
        ),
      );
      _reasonController.clear(); // Submit කළ පසු reason එක clear කරයි.
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text("Leave Management", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: Colors.purple,
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // --- කොටස 1: අලුත් නිවාඩුවක් Apply කරන Form එක ---
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Icon(Icons.add_circle_outline, color: Colors.purple),
                            SizedBox(width: 10),
                            Text("Apply for New Leave", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.purple)),
                          ],
                        ),
                        const Divider(height: 25),

                        _buildLabel("Leave Type"),
                        DropdownButtonFormField(
                          value: _selectedLeaveType,
                          items: _leaveTypes.map((t) => DropdownMenuItem(value: t, child: Text(t))).toList(),
                          onChanged: (val) => setState(() => _selectedLeaveType = val as String),
                          decoration: InputDecoration(
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          ),
                        ),

                        const SizedBox(height: 15),
                        _buildLabel("Select Date"),
                        InkWell(
                          onTap: () async {
                            DateTime? picked = await showDatePicker(
                              context: context,
                              initialDate: _selectedDate,
                              firstDate: DateTime.now(),
                              lastDate: DateTime(2027),
                            );
                            if (picked != null) setState(() => _selectedDate = picked);
                          },
                          child: Container(
                            padding: const EdgeInsets.all(15),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade400),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(DateFormat('yyyy-MM-dd').format(_selectedDate), style: const TextStyle(fontSize: 16)),
                                const Icon(Icons.calendar_month, color: Colors.purple),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: 15),
                        _buildLabel("Reason"),
                        TextFormField(
                          controller: _reasonController,
                          maxLines: 2,
                          decoration: InputDecoration(
                            hintText: "Why do you need leave?",
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                          validator: (v) => v!.isEmpty ? "Please enter a reason" : null,
                        ),

                        const SizedBox(height: 25),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.purple,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 15),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              elevation: 2,
                            ),
                            onPressed: _submitLeave,
                            child: const Text("SUBMIT REQUEST", style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.1)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // --- කොටස 2: කලින් ඉල්ලූ නිවාඩු ලැයිස්තුව ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 10.0),
                    child: Text("Recent Leave Requests", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  ),

                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _myLeaves.length,
                    itemBuilder: (context, index) {
                      final leave = _myLeaves[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          leading: CircleAvatar(
                            backgroundColor: leave['color'].withValues(alpha: 0.1),
                            child: Icon(Icons.event_note, color: leave['color']),
                          ),
                          title: Text(leave['type'], style: const TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Text("Requested for: ${leave['date']}"),
                          trailing: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: leave['color'].withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: leave['color']),
                            ),
                            child: Text(
                              leave['status'],
                              style: TextStyle(color: leave['color'], fontSize: 12, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5.0),
      child: Text(text, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: Colors.black87)),
    );
  }
}