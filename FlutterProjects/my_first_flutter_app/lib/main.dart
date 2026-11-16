import 'package:flutter/material.dart';
import 'core/db_connection.dart';
import 'profile.dart';
import 'student_records.dart';
import 'screens/student_list_screen.dart';
import 'screens/student_details_screen.dart';
import 'screens/add_student_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  debugPrint('TESTING NEON CONNECTION...');

  final message = await DbConnection.testConnection();
  debugPrint(message);

  await loadProfiles();

  profiles.sort((a, b) => a.name.compareTo(b.name));

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
          final profile = ModalRoute.of(context)!.settings.arguments as Profile;
          return StudentDetailsScreen(profile: profile);
        },
        '/add-student': (context) {
          return const AddStudentScreen();
        },
      },
    );
  }
}
