import 'package:flutter/material.dart';
import '../models/student.dart';
import '../models/subject.dart';
import '../viewmodels/enrollment_viewmodel.dart';
import '../viewmodels/student_viewmodel.dart';
import '../viewmodels/subject_viewmodel.dart';

class EnrollStudentScreen extends StatefulWidget {
  final Student student;

  const EnrollStudentScreen({super.key, required this.student});

  @override
  State<EnrollStudentScreen> createState() => _EnrollStudentScreenState();
}

class _EnrollStudentScreenState extends State<EnrollStudentScreen> {
  final _formKey = GlobalKey<FormState>();

  int? selectedStudentId;
  final Set<int> selectedSubjectIds = {};

  @override
  void initState() {
    super.initState();
    selectedStudentId = widget.student.student_id;
    loadSubjects();
  }

  Future<void> loadSubjects() async {
    await subjectViewModel.loadSubjects(showLoading: false);
    await enrollmentViewModel.loadRemainingSlots();
    await enrollmentViewModel.loadEnrolledSubjectIds(selectedStudentId!);

    if (!mounted) return;

    if (subjectViewModel.errorMessage != null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(subjectViewModel.errorMessage!)));
    }

    setState(() {});
  }

  List<Subject> get availableSubjects {
    return subjectViewModel.subjects
        .where(
          (subject) => !enrollmentViewModel.enrolledSubjectIds.contains(
            subject.subject_id,
          ),
        )
        .toList();
  }

  Future<void> changeStudent(int? studentId) async {
    if (studentId == null) return;

    selectedStudentId = studentId;
    selectedSubjectIds.clear();

    await enrollmentViewModel.loadEnrolledSubjectIds(studentId);

    if (!mounted) return;

    setState(() {});
  }

  String slotsText(Subject subject) {
    int? remaining = enrollmentViewModel.remainingSlots[subject.subject_id];

    if (remaining == null) {
      return 'No schedules yet';
    }

    if (remaining <= 0) {
      return 'Full. No slots left';
    }

    return 'Remaining slots: $remaining';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Enroll Student")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              DropdownButtonFormField<int>(
                value: selectedStudentId,
                isExpanded: true,
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
              SizedBox(height: 20),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Subjects",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "All schedules of a selected subject are included.",
                  style: TextStyle(fontSize: 14),
                ),
              ),
              SizedBox(height: 10),
              if (availableSubjects.isEmpty)
                const Text(
                  "No subjects available to enroll.",
                  style: TextStyle(fontSize: 16),
                ),
              ...availableSubjects.map((subject) {
                return CheckboxListTile(
                  value: selectedSubjectIds.contains(subject.subject_id),
                  title: Text(
                    "${subject.subject_code} - ${subject.subject_name}",
                  ),
                  subtitle: Text(slotsText(subject)),
                  controlAffinity: ListTileControlAffinity.leading,
                  onChanged: (checked) {
                    setState(() {
                      if (checked == true) {
                        selectedSubjectIds.add(subject.subject_id!);
                      } else {
                        selectedSubjectIds.remove(subject.subject_id);
                      }
                    });
                  },
                );
              }),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        if (selectedSubjectIds.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                "Please select at least one Subject",
                              ),
                            ),
                          );
                          return;
                        }

                        List<Subject> chosenSubjects = subjectViewModel.subjects
                            .where(
                              (subject) => selectedSubjectIds.contains(
                                subject.subject_id,
                              ),
                            )
                            .toList();

                        bool saved = await enrollmentViewModel.enrollStudent(
                          selectedStudentId!,
                          chosenSubjects,
                        );

                        if (!mounted) return;

                        if (!saved) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                enrollmentViewModel.errorMessage ??
                                    "Could not enroll student",
                              ),
                            ),
                          );
                          return;
                        }

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Student enrolled successfully"),
                          ),
                        );

                        Navigator.pop(context);
                      }
                    },
                    child: const Text("Enroll"),
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
