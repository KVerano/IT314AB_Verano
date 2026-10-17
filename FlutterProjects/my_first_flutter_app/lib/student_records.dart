import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'profile.dart';

Future<void> saveProfiles() async {
  final prefs = await SharedPreferences.getInstance();

  String studentData = jsonEncode(
    profiles.map((student) => student.toJson()).toList(),
  );

  await prefs.setString('profiles', studentData);
}

Future<void> loadProfiles() async {
  final prefs = await SharedPreferences.getInstance();

  String? studentData = prefs.getString('profiles');

  if (studentData == null) {
    return;
  }

  List<dynamic> savedStudents = jsonDecode(studentData);

  profiles.clear();

  profiles.addAll(
    savedStudents.map(
      (student) => Profile.fromJson(Map<String, dynamic>.from(student)),
    ),
  );
}
