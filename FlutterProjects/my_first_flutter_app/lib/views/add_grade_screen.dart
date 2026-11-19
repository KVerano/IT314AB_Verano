import 'package:flutter/material.dart';
import '../models/enrollment_detail.dart';
import '../models/grade.dart';
import '../viewmodels/enrollment_viewmodel.dart';
import '../viewmodels/grade_viewmodel.dart';
import '../viewmodels/student_viewmodel.dart';
import 'side_menu.dart';

class AddGradeScreen extends StatefulWidget {
  const AddGradeScreen({super.key});

  @override
  State<AddGradeScreen> createState() => _AddGradeScreenState();
}

class _AddGradeScreenState extends State<AddGradeScreen> {
  final _formKey = GlobalKey<FormState>();

  final gradeValueController = TextEditingController();
  final remarksController = TextEditingController();

  int? selectedStudentId;
  int? selectedEnrollmentId;
  int formVersion = 0;

  @override
  void dispose() {
    gradeValueController.dispose();
    remarksController.dispose();
    super.dispose();
  }

  List<EnrollmentDetail> get gradableEnrollments {
    if (selectedStudentId == null) return [];

    return enrollmentViewModel.enrollments.where((enrollment) {
      bool hasGrade = gradeViewModel.grades.any(
        (grade) => grade.enrollment_id == enrollment.enrollment_id,
      );
      return enrollment.status == 'Enrolled' && !hasGrade;
    }).toList();
  }

  Future<void> changeStudent(int? studentId) async {
    if (studentId == null) return;

    setState(() {
      selectedStudentId = studentId;
      selectedEnrollmentId = null;
    });

    await enrollmentViewModel.loadEnrollments(studentId, showLoading: false);
    await gradeViewModel.loadGrades(studentId, showLoading: false);

    if (!mounted) return;

    if (enrollmentViewModel.errorMessage != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(enrollmentViewModel.errorMessage!)),
      );
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("DBTC Enrollment Management System"),
      ),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SideMenu(selected: 'grades'),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 43,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Grades",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    DropdownButtonFormField<int>(
                      key: ValueKey(formVersion),
                      value: selectedStudentId,
                      isExpanded: true,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      decoration: const InputDecoration(
                        labelText: "Student",
                        border: OutlineInputBorder(),
                      ),
                      items: studentViewModel.students.map((student) {
                        return DropdownMenuItem<int>(
                          value: student.student_id!,
                          child: Text(
                            "${student.last_name}, ${student.first_name}",
                            overflow: TextOverflow.ellipsis,
                          ),
                        );
                      }).toList(),
                      onChanged: (value) {
                        changeStudent(value);
                      },
                      validator: (value) {
                        if (value == null) {
                          return "Please select a Student";
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 15),
                    if (selectedStudentId != null &&
                        gradableEnrollments.isEmpty) ...[
                      const Text(
                        "No enrolled subjects without a grade.",
                        style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(height: 15),
                    ],
                    DropdownButtonFormField<int>(
                      key: ValueKey(
                        "$formVersion-$selectedStudentId-${gradableEnrollments.length}",
                      ),
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
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(160, 40),
                          ),
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
                                selectedStudentId!,
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

                              gradeValueController.clear();
                              remarksController.clear();

                              setState(() {
                                selectedStudentId = null;
                                selectedEnrollmentId = null;
                                formVersion++;
                              });
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
          ),
        ],
      ),
    );
  }
}
