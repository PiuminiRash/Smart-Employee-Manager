import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'view_models/employee_view_model.dart';
import 'view_models/attendance_view_model.dart';
import 'views/login_screen.dart';
// import 'views/home_screen.dart'; // දැනට පාවිච්චි වෙන්නේ නැති නිසා comment කරා

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => EmployeeViewModel()),
        ChangeNotifierProvider(create: (context) => AttendanceViewModel()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Smart HR Manager',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        scaffoldBackgroundColor: const Color(0xFFF8F9FA),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
      // LoginScreen එක මෙතන පාවිච්චි වන නිසා 'Unused import' error එක එන්නේ නැහැ
      home: const LoginScreen(),
    );
  }
}