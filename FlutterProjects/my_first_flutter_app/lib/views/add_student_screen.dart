import 'package:flutter/material.dart';
import '../core/year_level_helper.dart';
import '../models/student.dart';
import '../viewmodels/student_viewmodel.dart';
import 'side_menu.dart';

class AddStudentScreen extends StatefulWidget {
  const AddStudentScreen({super.key});

  @override
  State<AddStudentScreen> createState() => _AddStudentScreenState();
}

class _AddStudentScreenState extends State<AddStudentScreen> {
  final _formKey = GlobalKey<FormState>();

  final studentIdController = TextEditingController();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final courseController = TextEditingController();
  final yearLevelController = TextEditingController();
  final emailController = TextEditingController();
  final contactNumberController = TextEditingController();

  @override
  void dispose() {
    studentIdController.dispose();
    firstNameController.dispose();
    lastNameController.dispose();
    courseController.dispose();
    yearLevelController.dispose();
    emailController.dispose();
    contactNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SideMenu(selected: 'students'),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Add Student",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      controller: studentIdController,
                      decoration: const InputDecoration(
                        labelText: "Student ID",
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return "Please enter Student ID";
                        }
                        if (studentViewModel.students.any(
                          (student) =>
                              student.student_number.trim() == value.trim(),
                        )) {
                          return "Student ID already exists";
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 15),
                    TextFormField(
                      controller: firstNameController,
                      decoration: const InputDecoration(
                        labelText: "First Name",
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return "Please enter First Name";
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 15),
                    TextFormField(
                      controller: lastNameController,
                      decoration: const InputDecoration(
                        labelText: "Last Name",
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return "Please enter Last Name";
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 15),
                    TextFormField(
                      controller: courseController,
                      decoration: const InputDecoration(
                        labelText: "Course",
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return "Please enter Course";
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 15),
                    TextFormField(
                      controller: yearLevelController,
                      decoration: const InputDecoration(
                        labelText: "Year Level",
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return "Please enter Year Level";
                        }
                        if (![
                          "1st year",
                          "2nd year",
                          "3rd year",
                          "4th year",
                        ].contains(value.trim().toLowerCase())) {
                          return "Enter 1st, 2nd, 3rd, or 4th Year";
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 15),
                    TextFormField(
                      controller: emailController,
                      decoration: const InputDecoration(
                        labelText: "Email Address",
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return "Please enter Email Address";
                        }

                        String email = value.trim();

                        if (email.startsWith("@") ||
                            email.endsWith(".") ||
                            email.contains(" ") ||
                            !email.contains("@") ||
                            !email.contains(".")) {
                          return "Please enter a valid email address";
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 15),
                    TextFormField(
                      controller: contactNumberController,
                      decoration: const InputDecoration(
                        labelText: "Contact Number",
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.phone,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return "Please enter Contact Number";
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(160, 40),
                          ),
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              Student newStudent = Student(
                                student_number: studentIdController.text.trim(),
                                first_name: firstNameController.text.trim(),
                                last_name: lastNameController.text.trim(),
                                email: emailController.text.trim(),
                                course: courseController.text.trim(),
                                year_level: yearLevelToNumber(
                                  yearLevelController.text,
                                ),
                                contact_number: contactNumberController.text
                                    .trim(),
                              );

                              bool saved = await studentViewModel.addStudent(
                                newStudent,
                              );

                              if (!mounted) return;

                              if (!saved) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      studentViewModel.errorMessage ??
                                          "Could not save student",
                                    ),
                                  ),
                                );
                                return;
                              }

                              studentIdController.clear();
                              firstNameController.clear();
                              lastNameController.clear();
                              courseController.clear();
                              yearLevelController.clear();
                              emailController.clear();
                              contactNumberController.clear();

                              Navigator.pop(context, true);
                            }
                          },
                          child: const Text("Enroll Student"),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
