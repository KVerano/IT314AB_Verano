import 'package:flutter/material.dart';
import '../core/year_level_helper.dart';
import '../models/student.dart';
import '../viewmodels/student_viewmodel.dart';

Future<Student?> showEditStudentDialog(BuildContext context, Student student) {
  String editedFirstName = student.first_name;
  String editedLastName = student.last_name;
  String editedStudentNumber = student.student_number;
  String editedCourse = student.course;
  String editedYearLevel = yearLevelToText(student.year_level);
  String editedEmail = student.email;
  String editedContactNumber = student.contact_number;

  return showDialog<Student>(
    context: context,
    builder: (dialogContext) {
      return AlertDialog(
        title: Text("Edit ${student.first_name} ${student.last_name}"),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                initialValue: student.first_name,
                onChanged: (value) {
                  editedFirstName = value;
                },
                decoration: const InputDecoration(
                  labelText: "First Name",
                  border: OutlineInputBorder(borderRadius: BorderRadius.zero),
                ),
              ),
              SizedBox(height: 10),
              TextFormField(
                initialValue: student.last_name,
                onChanged: (value) {
                  editedLastName = value;
                },
                decoration: const InputDecoration(
                  labelText: "Last Name",
                  border: OutlineInputBorder(borderRadius: BorderRadius.zero),
                ),
              ),
              SizedBox(height: 10),
              TextFormField(
                initialValue: student.student_number,
                onChanged: (value) {
                  editedStudentNumber = value;
                },
                decoration: const InputDecoration(
                  labelText: "Student ID",
                  border: OutlineInputBorder(borderRadius: BorderRadius.zero),
                ),
              ),
              SizedBox(height: 10),
              TextFormField(
                initialValue: student.course,
                onChanged: (value) {
                  editedCourse = value;
                },
                decoration: const InputDecoration(
                  labelText: "Course",
                  border: OutlineInputBorder(borderRadius: BorderRadius.zero),
                ),
              ),
              SizedBox(height: 10),
              TextFormField(
                initialValue: yearLevelToText(student.year_level),
                onChanged: (value) {
                  editedYearLevel = value;
                },
                decoration: const InputDecoration(
                  labelText: "Year Level",
                  border: OutlineInputBorder(borderRadius: BorderRadius.zero),
                ),
              ),
              SizedBox(height: 10),
              TextFormField(
                initialValue: student.email,
                onChanged: (value) {
                  editedEmail = value;
                },
                decoration: const InputDecoration(
                  labelText: "Email",
                  border: OutlineInputBorder(borderRadius: BorderRadius.zero),
                ),
              ),
              SizedBox(height: 10),
              TextFormField(
                initialValue: student.contact_number,
                onChanged: (value) {
                  editedContactNumber = value;
                },
                decoration: const InputDecoration(
                  labelText: "Contact Number",
                  border: OutlineInputBorder(borderRadius: BorderRadius.zero),
                ),
                keyboardType: TextInputType.phone,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () async {
              if (editedFirstName.trim().isEmpty ||
                  editedLastName.trim().isEmpty ||
                  editedStudentNumber.trim().isEmpty ||
                  editedCourse.trim().isEmpty ||
                  editedYearLevel.trim().isEmpty ||
                  editedEmail.trim().isEmpty ||
                  editedContactNumber.trim().isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Please enter valid student information"),
                  ),
                );
                return;
              }

              int yearLevel = yearLevelToNumber(editedYearLevel);

              if (yearLevel == 0) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Enter 1st, 2nd, 3rd, or 4th Year"),
                  ),
                );
                return;
              }

              bool duplicateId = studentViewModel.students.any(
                (other) =>
                    other.student_id != student.student_id &&
                    other.student_number.trim() == editedStudentNumber.trim(),
              );

              if (duplicateId) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Student ID already exists")),
                );
                return;
              }

              Student updatedStudent = Student(
                student_id: student.student_id,
                student_number: editedStudentNumber.trim(),
                first_name: editedFirstName.trim(),
                last_name: editedLastName.trim(),
                email: editedEmail.trim(),
                course: editedCourse.trim(),
                year_level: yearLevel,
                contact_number: editedContactNumber.trim(),
              );

              bool saved = await studentViewModel.updateStudent(updatedStudent);

              if (!context.mounted) return;

              if (!saved) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      studentViewModel.errorMessage ?? "Could not save",
                    ),
                  ),
                );
                return;
              }

              if (!dialogContext.mounted) return;

              Navigator.pop(dialogContext, updatedStudent);
            },
            child: const Text("Save"),
          ),
        ],
      );
    },
  );
}
