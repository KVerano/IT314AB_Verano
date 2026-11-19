import 'package:flutter/material.dart';
import '../core/year_level_helper.dart';
import '../models/student.dart';
import '../viewmodels/student_viewmodel.dart';
import 'edit_student_dialog.dart';
import 'delete_student_dialog.dart';
import 'side_menu.dart';

class StudentListScreen extends StatefulWidget {
  const StudentListScreen({super.key});

  @override
  State<StudentListScreen> createState() => _StudentListScreenState();
}

class _StudentListScreenState extends State<StudentListScreen> {
  String searchText = '';

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

  List<Student> get filteredStudents {
    String text = searchText.trim().toLowerCase();

    List<Student> filtered = studentViewModel.students.where((student) {
      return student.first_name.toLowerCase().contains(text) ||
          student.last_name.toLowerCase().contains(text) ||
          "${student.first_name} ${student.last_name}".toLowerCase().contains(
            text,
          ) ||
          student.student_number.toLowerCase().contains(text);
    }).toList();

    filtered.sort((a, b) {
      int surnameOrder = a.last_name.toLowerCase().compareTo(
        b.last_name.toLowerCase(),
      );

      if (surnameOrder != 0) {
        return surnameOrder;
      }

      return a.first_name.toLowerCase().compareTo(b.first_name.toLowerCase());
    });

    return filtered;
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
        elevation: 0,
        margin: EdgeInsets.zero,
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
      appBar: AppBar(title: const Text("DBTC Enrollment Management System")),
      body: Row(
        children: [
          const SideMenu(selected: 'students'),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Students",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(160, 40),
                        ),
                        onPressed: () async {
                          final result = await Navigator.pushNamed(
                            context,
                            '/add-student',
                          );

                          if (result == true) {
                            setState(() {});
                          }
                        },
                        child: const Text("Add Student"),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
                  child: TextField(
                    onChanged: (value) {
                      setState(() {
                        searchText = value;
                      });
                    },
                    decoration: const InputDecoration(
                      hintText: "Search by Name or Student ID",
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                Expanded(
                  child: ListenableBuilder(
                    listenable: studentViewModel,
                    builder: (context, child) {
                      List<Student> students = filteredStudents;

                      return studentViewModel.isLoading
                          ? const Center(child: CircularProgressIndicator())
                          : students.isEmpty
                          ? const Center(
                              child: Text(
                                "No students found.",
                                style: TextStyle(fontSize: 18),
                              ),
                            )
                          : ListView.builder(
                              padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
                              itemCount: students.length,
                              itemBuilder: (context, index) {
                                return Column(
                                  children: [
                                    if (index == 0) SizedBox(height: 15),
                                    profileCard(context, students[index]),
                                    SizedBox(height: 10),
                                  ],
                                );
                              },
                            );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
