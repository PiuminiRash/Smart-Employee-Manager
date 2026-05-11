import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'view_models/employee_view_model.dart';
import 'views/home_screen.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        // Meka danata error pennavi, mokada api thama ViewModel eka hadala nathi nisa
        ChangeNotifierProvider(create: (_) => EmployeeViewModel()),
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
      title: 'Smart Employee Manager',
      theme: ThemeData(
        useMaterial3: true,
        // Error eka fix kala thana: ColorScheme.fromSeed kiyala danna ona
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        textTheme: GoogleFonts.poppinsTextTheme(),
      ),
      home: const HomeScreen(), // Api hadanna yana Home Screen eka
      debugShowCheckedModeBanner: false,
    );
  }
}