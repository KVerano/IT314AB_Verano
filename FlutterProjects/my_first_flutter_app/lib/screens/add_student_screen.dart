import 'package:flutter/material.dart';
import '../profile.dart';
import '../student_records.dart';

class AddStudentScreen extends StatefulWidget {
  const AddStudentScreen({super.key});

  @override
  State<AddStudentScreen> createState() => _AddStudentScreenState();
}

class _AddStudentScreenState extends State<AddStudentScreen> {
  final _formKey = GlobalKey<FormState>();

  final studentIdController = TextEditingController();
  final fullNameController = TextEditingController();
  final courseController = TextEditingController();
  final yearLevelController = TextEditingController();
  final emailController = TextEditingController();

  @override
  void dispose() {
    studentIdController.dispose();
    fullNameController.dispose();
    courseController.dispose();
    yearLevelController.dispose();
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add Student")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
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
                  if (profiles.any(
                    (profile) => profile.studentId.trim() == value.trim(),
                  )) {
                    return "Student ID already exists";
                  }
                  return null;
                },
              ),
              SizedBox(height: 15),
              TextFormField(
                controller: fullNameController,
                decoration: const InputDecoration(
                  labelText: "Full Name",
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Please enter Full Name";
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
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        Profile newStudent = Profile(
                          image: "",
                          name: fullNameController.text.trim(),
                          course: courseController.text.trim(),
                          yearLevel: yearLevelController.text.trim(),
                          age: 0,
                          hobby: "Not provided",
                          studentId: studentIdController.text.trim(),
                          email: emailController.text.trim(),
                          favoriteSubject: "Not provided",
                          active: true,
                        );

                        profiles.add(newStudent);
                        profiles.sort((a, b) => a.name.compareTo(b.name));

                        await saveProfiles();

                        studentIdController.clear();
                        fullNameController.clear();
                        courseController.clear();
                        yearLevelController.clear();
                        emailController.clear();

                        if (!mounted) return;

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
    );
  }
}
