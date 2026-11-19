import 'package:flutter/material.dart';
import '../models/enrollment_detail.dart';
import '../models/grade.dart';
import '../models/student.dart';
import '../viewmodels/enrollment_viewmodel.dart';
import '../viewmodels/grade_viewmodel.dart';

class AddGradeScreen extends StatefulWidget {
  final Student student;

  const AddGradeScreen({super.key, required this.student});

  @override
  State<AddGradeScreen> createState() => _AddGradeScreenState();
}

class _AddGradeScreenState extends State<AddGradeScreen> {
  final _formKey = GlobalKey<FormState>();

  final gradeValueController = TextEditingController();
  final remarksController = TextEditingController();

  int? selectedEnrollmentId;

  @override
  void dispose() {
    gradeValueController.dispose();
    remarksController.dispose();
    super.dispose();
  }

  List<EnrollmentDetail> get gradableEnrollments {
    return enrollmentViewModel.enrollments.where((enrollment) {
      bool hasGrade = gradeViewModel.grades.any(
        (grade) => grade.enrollment_id == enrollment.enrollment_id,
      );
      return enrollment.status == 'Enrolled' && !hasGrade;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add Grade")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Text(
                "${widget.student.last_name}, ${widget.student.first_name}",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              if (gradableEnrollments.isEmpty) ...[
                const Text(
                  "No enrolled subjects without a grade.",
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 15),
              ],
              DropdownButtonFormField<int>(
                value: selectedEnrollmentId,
                isExpanded: true,
                decoration: const InputDecoration(
                  labelText: "Subject",
                  border: OutlineInputBorder(),
                ),
                items: gradableEnrollments.map((enrollment) {
                  return DropdownMenuItem<int>(
                    value: enrollment.enrollment_id,
                    child: Text(
                      "${enrollment.subject_code} - ${enrollment.subject_name}",
                      overflow: TextOverflow.ellipsis,
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  selectedEnrollmentId = value;
                },
                validator: (value) {
                  if (value == null) {
                    return "Please select a Subject";
                  }
                  return null;
                },
              ),
              SizedBox(height: 15),
              TextFormField(
                controller: gradeValueController,
                decoration: const InputDecoration(
                  labelText: "Grade Value (0 to 100)",
                  border: OutlineInputBorder(),
                ),
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Please enter Grade Value";
                  }
                  double? grade = double.tryParse(value.trim());
                  if (grade == null || grade < 0 || grade > 100) {
                    return "Grade must be a number from 0 to 100";
                  }
                  return null;
                },
              ),
              SizedBox(height: 15),
              TextFormField(
                controller: remarksController,
                decoration: const InputDecoration(
                  labelText: "Remarks (optional)",
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        Grade newGrade = Grade(
                          enrollment_id: selectedEnrollmentId!,
                          grade_value: double.parse(
                            gradeValueController.text.trim(),
                          ),
                          remarks: remarksController.text.trim().isEmpty
                              ? null
                              : remarksController.text.trim(),
                        );

                        bool saved = await gradeViewModel.addGrade(
                          newGrade,
                          widget.student.student_id!,
                        );

                        if (!mounted) return;

                        if (!saved) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                gradeViewModel.errorMessage ??
                                    "Could not save grade",
                              ),
                            ),
                          );
                          return;
                        }

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Grade added successfully"),
                          ),
                        );

                        Navigator.pop(context);
                      }
                    },
                    child: const Text("Add Grade"),
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
