import 'package:flutter/material.dart';
import '../core/time_helper.dart';
import '../models/enrollment_detail.dart';
import '../models/grade_detail.dart';
import '../models/student.dart';
import '../viewmodels/enrollment_viewmodel.dart';
import '../viewmodels/grade_viewmodel.dart';
import 'enroll_student_screen.dart';
import 'change_schedule_dialog.dart';
import 'drop_enrollment_dialog.dart';
import 'add_grade_screen.dart';
import 'edit_grade_dialog.dart';
import 'delete_grade_dialog.dart';

class EnrollmentsGradesScreen extends StatefulWidget {
  final Student student;

  const EnrollmentsGradesScreen({super.key, required this.student});

  @override
  State<EnrollmentsGradesScreen> createState() =>
      _EnrollmentsGradesScreenState();
}

class _EnrollmentsGradesScreenState extends State<EnrollmentsGradesScreen>
    with SingleTickerProviderStateMixin {
  late final TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this);
    loadEnrollments();
    loadGrades();
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  Future<void> openForm() async {
    if (tabController.index == 0) {
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) {
            return EnrollStudentScreen(student: widget.student);
          },
        ),
      );

      if (!mounted) return;

      await enrollmentViewModel.loadEnrollments(
        widget.student.student_id!,
        showLoading: false,
      );
    } else {
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) {
            return AddGradeScreen(student: widget.student);
          },
        ),
      );
    }
  }

  Future<void> loadEnrollments() async {
    await enrollmentViewModel.loadEnrollments(widget.student.student_id!);

    if (!mounted) return;

    if (enrollmentViewModel.errorMessage != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(enrollmentViewModel.errorMessage!)),
      );
    }
  }

  Future<void> loadGrades() async {
    await gradeViewModel.loadGrades(widget.student.student_id!);

    if (!mounted) return;

    if (gradeViewModel.errorMessage != null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(gradeViewModel.errorMessage!)));
    }
  }

  Widget enrollmentCard(EnrollmentDetail enrollment) {
    return Card(
      color: Colors.grey.shade200,
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              enrollment.subject_code,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 5),
            Text(
              enrollment.subject_name,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 5),
            ...enrollment.schedules.map((schedule) {
              bool isMain = schedule.schedule_id == enrollment.schedule_id;

              return Padding(
                padding: const EdgeInsets.only(bottom: 5),
                child: Text(
                  "${schedule.day_of_week}, ${formatTime12Hour(schedule.start_time)} - ${formatTime12Hour(schedule.end_time)} (${schedule.room})",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: isMain ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              );
            }),
            Text(
              "Status: ${enrollment.status}",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
            if (enrollment.status == 'Enrolled') ...[
              SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // change schedule button
                  SizedBox(
                    width: 175,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 6),
                      ),
                      onPressed: () async {
                        bool changed = await showChangeScheduleDialog(
                          context,
                          enrollment,
                        );

                        if (!mounted) return;

                        if (changed) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Schedule changed"),
                              duration: Duration(seconds: 2),
                            ),
                          );
                        }
                      },
                      icon: const Icon(Icons.swap_horiz, size: 16),
                      label: const Text(
                        "Change Schedule",
                        maxLines: 1,
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                  ),

                  SizedBox(width: 5),

                  // drop button
                  SizedBox(
                    width: 105,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 6),
                      ),
                      onPressed: () async {
                        bool confirmed = await showDropEnrollmentDialog(
                          context,
                          enrollment,
                        );

                        if (!confirmed) return;

                        bool dropped = await enrollmentViewModel.dropEnrollment(
                          enrollment,
                        );

                        if (!mounted) return;

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              dropped
                                  ? "${enrollment.subject_code} dropped"
                                  : enrollmentViewModel.errorMessage ??
                                        "Could not drop enrollment",
                            ),
                            duration: Duration(seconds: 2),
                          ),
                        );
                      },
                      icon: const Icon(Icons.remove_circle, size: 16),
                      label: const Text("Drop", style: TextStyle(fontSize: 12)),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget gradeCard(GradeDetail grade) {
    return Card(
      color: Colors.grey.shade200,
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              grade.subject_code,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 5),
            Text(
              grade.subject_name,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 5),
            Text(
              "Grade: ${grade.grade_value}",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            if (grade.remarks != null && grade.remarks!.isNotEmpty) ...[
              SizedBox(height: 5),
              Text(
                "Remarks: ${grade.remarks}",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
            ],
            if (grade.date_recorded != null) ...[
              SizedBox(height: 5),
              Text(
                "Recorded: ${grade.date_recorded.toString().substring(0, 10)}",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14),
              ),
            ],
            SizedBox(height: 15),
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
                    onPressed: () async {
                      bool updated = await showEditGradeDialog(context, grade);

                      if (!mounted) return;

                      if (updated) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Grade updated"),
                            duration: Duration(seconds: 2),
                          ),
                        );
                      }
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
                      bool confirmed = await showDeleteGradeDialog(
                        context,
                        grade,
                      );

                      if (!confirmed) return;

                      bool deleted = await gradeViewModel.deleteGrade(grade);

                      if (!mounted) return;

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            deleted
                                ? "Grade for ${grade.subject_code} removed"
                                : gradeViewModel.errorMessage ??
                                      "Could not delete grade",
                          ),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    },
                    icon: const Icon(Icons.delete, size: 16),
                    label: const Text("Delete", style: TextStyle(fontSize: 12)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget enrollmentsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: ListenableBuilder(
        listenable: enrollmentViewModel,
        builder: (context, child) {
          return enrollmentViewModel.isLoading
              ? const Center(child: CircularProgressIndicator())
              : enrollmentViewModel.enrollments.isEmpty
              ? const Text(
                  "No enrollments yet.",
                  style: TextStyle(fontSize: 16),
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: enrollmentViewModel.enrollments.map((enrollment) {
                    return enrollmentCard(enrollment);
                  }).toList(),
                );
        },
      ),
    );
  }

  Widget gradesTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: ListenableBuilder(
        listenable: gradeViewModel,
        builder: (context, child) {
          return gradeViewModel.isLoading
              ? const Center(child: CircularProgressIndicator())
              : gradeViewModel.grades.isEmpty
              ? const Text("No grades yet.", style: TextStyle(fontSize: 16))
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: gradeViewModel.grades.map((grade) {
                    return gradeCard(grade);
                  }).toList(),
                );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "${widget.student.last_name}, ${widget.student.first_name}",
        ),
        actions: [
          IconButton(
            onPressed: () {
              openForm();
            },
            icon: const Icon(Icons.add),
          ),
        ],
        bottom: TabBar(
          controller: tabController,
          tabs: const [
            Tab(text: "Enrollments"),
            Tab(text: "Grades"),
          ],
        ),
      ),
      body: TabBarView(
        controller: tabController,
        children: [enrollmentsTab(), gradesTab()],
      ),
    );
  }
}
