import 'package:flutter/material.dart';
import '../core/year_level_helper.dart';
import '../models/student.dart';
import '../viewmodels/student_viewmodel.dart';
import 'edit_student_dialog.dart';
import 'delete_student_dialog.dart';
import 'enrollments_grades_screen.dart';

class StudentDetailsScreen extends StatefulWidget {
  final Student profile;

  const StudentDetailsScreen({super.key, required this.profile});

  @override
  State<StudentDetailsScreen> createState() => _StudentDetailsScreenState();
}

class _StudentDetailsScreenState extends State<StudentDetailsScreen> {
  late Student profile = widget.profile;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Student Details")),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            const Center(
              child: Icon(Icons.person, size: 150, color: Colors.grey),
            ),

            SizedBox(height: 50),

            Text(
              "Name: ${profile.last_name}, ${profile.first_name}",
              style: TextStyle(fontSize: 18),
            ),

            SizedBox(height: 10),

            Text(
              "Student ID: ${profile.student_number}",
              style: TextStyle(fontSize: 18),
            ),

            SizedBox(height: 10),

            Text("Course: ${profile.course}", style: TextStyle(fontSize: 18)),

            SizedBox(height: 10),

            Text(
              "Year Level: ${yearLevelToText(profile.year_level)}",
              style: TextStyle(fontSize: 18),
            ),

            SizedBox(height: 10),

            Text("Email: ${profile.email}", style: TextStyle(fontSize: 18)),

            SizedBox(height: 10),

            Text(
              "Contact Number: ${profile.contact_number}",
              style: TextStyle(fontSize: 18),
            ),

            SizedBox(height: 50),

            Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ElevatedButton.icon(
                    onPressed: () async {
                      Student? updated = await showEditStudentDialog(
                        context,
                        profile,
                      );

                      if (!mounted) return;

                      if (updated != null) {
                        setState(() {
                          profile = updated;
                        });
                      }
                    },
                    icon: const Icon(Icons.edit),
                    label: const Text("Edit"),
                  ),

                  SizedBox(width: 10),

                  ElevatedButton.icon(
                    onPressed: () async {
                      bool confirmed = await showDeleteStudentDialog(
                        context,
                        profile,
                      );

                      if (!confirmed) return;

                      bool deleted = await studentViewModel.deleteStudent(
                        profile,
                      );

                      if (!mounted) return;

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            deleted
                                ? "${profile.first_name} ${profile.last_name} removed"
                                : studentViewModel.errorMessage ??
                                      "Could not delete student",
                          ),
                          duration: Duration(seconds: 2),
                        ),
                      );

                      if (deleted) {
                        Navigator.pop(context);
                      }
                    },
                    icon: const Icon(Icons.delete),
                    label: const Text("Delete"),
                  ),
                ],
              ),
            ),

            SizedBox(height: 30),

            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return EnrollmentsGradesScreen(student: profile);
                      },
                    ),
                  );
                },
                child: const Text("Enrollments and Grades"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
