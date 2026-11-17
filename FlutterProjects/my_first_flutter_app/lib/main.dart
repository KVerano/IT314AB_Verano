import 'package:flutter/material.dart';
import 'models/student.dart';
import 'screens/student_list_screen.dart';
import 'screens/student_details_screen.dart';
import 'screens/add_student_screen.dart';

void main() {
  // ma'am ako gi sort lang by surname instead sa first name since sa akong profile ga una ang mga surnames. thank you
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/student-list',
      routes: {
        '/student-list': (context) {
          return const StudentListScreen();
        },
        '/student-details': (context) {
          final profile = ModalRoute.of(context)!.settings.arguments as Student;
          return StudentDetailsScreen(profile: profile);
        },
        '/add-student': (context) {
          return const AddStudentScreen();
        },
      },
    );
  }
}
