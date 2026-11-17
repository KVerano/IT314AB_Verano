import 'package:flutter/material.dart';
import '../core/year_level_helper.dart';
import '../models/student.dart';
import '../viewmodels/student_viewmodel.dart';
import 'edit_student_dialog.dart';
import 'delete_student_dialog.dart';

class StudentListScreen extends StatefulWidget {
  const StudentListScreen({super.key});

  @override
  State<StudentListScreen> createState() => _StudentListScreenState();
}

class _StudentListScreenState extends State<StudentListScreen> {
  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    String message = await studentViewModel.checkConnection();
    await studentViewModel.loadStudents();

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(studentViewModel.errorMessage ?? message),
        duration: Duration(seconds: 6),
      ),
    );
  }

  Widget profileCard(BuildContext context, Student profile) {
    return InkWell(
      onTap: () async {
        print("${profile.first_name} ${profile.last_name} profile selected");

        await Navigator.pushNamed(
          context,
          '/student-details',
          arguments: profile,
        );

        if (!mounted) return;

        setState(() {});
      },
      child: Card(
        color: Colors.white.withOpacity(0.3),
        elevation: 0,
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 50),
              Icon(Icons.person, size: 130, color: Colors.grey),
              SizedBox(height: 30),
              Text(
                "${profile.last_name}, ${profile.first_name}",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                profile.course,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 10),
              Text(
                yearLevelToText(profile.year_level),
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 10),
              Text(
                "Student ID: ${profile.student_number}",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 10),
              Text(
                "Email: ${profile.email}",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 10),
              Text(
                "Contact: ${profile.contact_number}",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // edit button
                  SizedBox(
                    width: 105,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 6),
                      ),
                      onPressed: () {
                        showEditStudentDialog(context, profile);
                      },
                      icon: const Icon(Icons.edit, size: 16),
                      label: const Text("Edit", style: TextStyle(fontSize: 12)),
                    ),
                  ),

                  SizedBox(width: 5),

                  // delete button
                  SizedBox(
                    width: 105,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 6),
                      ),
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
                      },
                      icon: const Icon(Icons.delete, size: 16),
                      label: const Text(
                        "Delete",
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 231, 227, 227),
      appBar: AppBar(
        title: const Text("My First Flutter Application"),
        actions: [
          // subject list button kemeru (comment for organization huehue)
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, '/subject-list');
            },
            icon: const Icon(Icons.menu_book),
          ),

          // add student button kemeru
          IconButton(
            onPressed: () async {
              final result = await Navigator.pushNamed(context, '/add-student');

              if (result == true) {
                setState(() {});
              }
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: ListenableBuilder(
        listenable: studentViewModel,
        builder: (context, child) {
          return studentViewModel.isLoading
              ? const Center(child: CircularProgressIndicator())
              : studentViewModel.students.isEmpty
              ? const Center(
                  child: Text(
                    "No students found.",
                    style: TextStyle(fontSize: 18),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(8),
                  itemCount: studentViewModel.students.length,
                  itemBuilder: (context, index) {
                    return profileCard(
                      context,
                      studentViewModel.students[index],
                    );
                  },
                );
        },
      ),
    );
  }
}
