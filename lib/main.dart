import 'package:flutter/material.dart';
import 'package:flutter_task_aadesh/ui/dashboard_ui.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

 
  // This widget is the root of the application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
      primaryColor: const Color.fromARGB(255, 0, 0, 0),
      ),
      home: const NewDiaryScreen(),
    );
  }
}