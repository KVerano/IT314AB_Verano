import 'package:flutter/material.dart';
import '../models/subject.dart';
import '../viewmodels/enrollment_viewmodel.dart';
import '../viewmodels/student_viewmodel.dart';
import '../viewmodels/subject_viewmodel.dart';
import 'side_menu.dart';

class EnrollStudentScreen extends StatefulWidget {
  const EnrollStudentScreen({super.key});

  @override
  State<EnrollStudentScreen> createState() => _EnrollStudentScreenState();
}

class _EnrollStudentScreenState extends State<EnrollStudentScreen> {
  final _formKey = GlobalKey<FormState>();

  int? selectedStudentId;
  final Set<int> selectedSubjectIds = {};
  int formVersion = 0;

  @override
  void initState() {
    super.initState();
    Future.microtask(loadSubjects);
  }

  Future<void> loadSubjects() async {
    await subjectViewModel.loadSubjects(showLoading: false);
    await enrollmentViewModel.loadRemainingSlots();

    if (!mounted) return;

    if (subjectViewModel.errorMessage != null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(subjectViewModel.errorMessage!)));
    }

    setState(() {});
  }

  List<Subject> get availableSubjects {
    if (selectedStudentId == null) return [];

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

    setState(() {
      selectedStudentId = studentId;
      selectedSubjectIds.clear();
    });

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
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("DBTC Enrollment Management System"),
      ),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SideMenu(selected: 'enrollments'),
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
                          "Enrollments",
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
                    SizedBox(height: 20),
                    const Text(
                      "Subjects",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 3),
                    const Text(
                      "All schedules of a selected subject are included.",
                      style: TextStyle(fontSize: 15),
                    ),
                    SizedBox(height: 10),
                    if (selectedStudentId != null && availableSubjects.isEmpty)
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
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(160, 40),
                          ),
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

                              List<Subject> chosenSubjects = subjectViewModel
                                  .subjects
                                  .where(
                                    (subject) => selectedSubjectIds.contains(
                                      subject.subject_id,
                                    ),
                                  )
                                  .toList();

                              bool saved = await enrollmentViewModel
                                  .enrollStudent(
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
                                  content: Text(
                                    "Student enrolled successfully",
                                  ),
                                ),
                              );

                              await enrollmentViewModel.loadRemainingSlots();

                              if (!mounted) return;

                              setState(() {
                                selectedStudentId = null;
                                selectedSubjectIds.clear();
                                formVersion++;
                              });
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
          ),
        ],
      ),
    );
  }
}
