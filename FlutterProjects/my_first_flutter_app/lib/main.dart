import 'package:flutter/material.dart';
import 'models/student.dart';
import 'views/student_list_screen.dart';
import 'views/student_details_screen.dart';
import 'views/add_student_screen.dart';
import 'views/subject_list_screen.dart';
import 'views/add_subject_screen.dart';
import 'models/subject.dart';
import 'views/subject_details_screen.dart';
import 'views/add_schedule_screen.dart';
import 'views/enroll_student_screen.dart';
import 'views/add_grade_screen.dart';

void main() {
  // ma'am ako gi sort lang by surname instead sa first name since sa akong profile ga una ang mga surnames. thank you
  runApp(const MyApp());
}

class NoTransitionsBuilder extends PageTransitionsBuilder {
  const NoTransitionsBuilder();

  @override
  Widget buildTransitions<T>(
    PageRoute<T> route,
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return child;
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF0066CC),
          primary: const Color(0xFF0066CC),
        ),
        scaffoldBackgroundColor: const Color(0xFFF3F4F6),
        textTheme: ThemeData.light().textTheme.apply(
          bodyColor: const Color(0xFF003366),
          displayColor: const Color(0xFF003366),
        ),
        pageTransitionsTheme: const PageTransitionsTheme(
          builders: {
            TargetPlatform.windows: NoTransitionsBuilder(),
            TargetPlatform.android: NoTransitionsBuilder(),
            TargetPlatform.iOS: NoTransitionsBuilder(),
            TargetPlatform.linux: NoTransitionsBuilder(),
            TargetPlatform.macOS: NoTransitionsBuilder(),
          },
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF002244),
          foregroundColor: Colors.white,
        ),
        cardTheme: CardThemeData(
          color: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: const BorderSide(color: Color(0xFFD9D9D9)),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF003366),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFFD9D9D9)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFF0066CC), width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.red),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.red, width: 2),
          ),
        ),
      ),
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

        '/subject-list': (context) {
          return const SubjectListScreen();
        },
        '/add-subject': (context) {
          return const AddSubjectScreen();
        },
        '/add-schedule': (context) {
          return const AddScheduleScreen();
        },
        '/subject-details': (context) {
          final subject = ModalRoute.of(context)!.settings.arguments as Subject;
          return SubjectDetailsScreen(subject: subject);
        },
        '/enroll-student': (context) {
          return const EnrollStudentScreen();
        },
        '/add-grade': (context) {
          return const AddGradeScreen();
        },
      },
    );
  }
}
