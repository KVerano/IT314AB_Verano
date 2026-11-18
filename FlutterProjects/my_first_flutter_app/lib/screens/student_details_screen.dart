import 'package:flutter/material.dart';
import '../core/time_helper.dart';
import '../core/year_level_helper.dart';
import '../models/enrollment_detail.dart';
import '../models/student.dart';
import '../viewmodels/enrollment_viewmodel.dart';
import '../viewmodels/student_viewmodel.dart';
import 'edit_student_dialog.dart';
import 'delete_student_dialog.dart';
import 'enroll_student_screen.dart';
import 'change_schedule_dialog.dart';
import 'drop_enrollment_dialog.dart';

class StudentDetailsScreen extends StatefulWidget {
  final Student profile;

  const StudentDetailsScreen({super.key, required this.profile});

  @override
  State<StudentDetailsScreen> createState() => _StudentDetailsScreenState();
}

class _StudentDetailsScreenState extends State<StudentDetailsScreen> {
  late Student profile = widget.profile;

  @override
  void initState() {
    super.initState();
    loadEnrollments();
  }

  Future<void> loadEnrollments() async {
    await enrollmentViewModel.loadEnrollments(profile.student_id!);

    if (!mounted) return;

    if (enrollmentViewModel.errorMessage != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(enrollmentViewModel.errorMessage!)),
      );
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Student Details")),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            const Center(
              child: Icon(Icons.person, size: 150, color: Colors.grey),
            ),

            SizedBox(height: 50),

            Text(
              "Name: ${profile.last_name}, ${profile.first_name}",
              style: TextStyle(fontSize: 18),
            ),

            SizedBox(height: 10),

            Text(
              "Student ID: ${profile.student_number}",
              style: TextStyle(fontSize: 18),
            ),

            SizedBox(height: 10),

            Text("Course: ${profile.course}", style: TextStyle(fontSize: 18)),

            SizedBox(height: 10),

            Text(
              "Year Level: ${yearLevelToText(profile.year_level)}",
              style: TextStyle(fontSize: 18),
            ),

            SizedBox(height: 10),

            Text("Email: ${profile.email}", style: TextStyle(fontSize: 18)),

            SizedBox(height: 10),

            Text(
              "Contact Number: ${profile.contact_number}",
              style: TextStyle(fontSize: 18),
            ),

            SizedBox(height: 50),

            Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ElevatedButton.icon(
                    onPressed: () async {
                      Student? updated = await showEditStudentDialog(
                        context,
                        profile,
                      );

                      if (!mounted) return;

                      if (updated != null) {
                        setState(() {
                          profile = updated;
                        });
                      }
                    },
                    icon: const Icon(Icons.edit),
                    label: const Text("Edit"),
                  ),

                  SizedBox(width: 10),

                  ElevatedButton.icon(
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

                      if (deleted) {
                        Navigator.pop(context);
                      }
                    },
                    icon: const Icon(Icons.delete),
                    label: const Text("Delete"),
                  ),
                ],
              ),
            ),

            SizedBox(height: 40),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Enrollments",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                ElevatedButton.icon(
                  onPressed: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return EnrollStudentScreen(student: profile);
                        },
                      ),
                    );

                    if (!mounted) return;

                    await enrollmentViewModel.loadEnrollments(
                      profile.student_id!,
                      showLoading: false,
                    );
                  },
                  icon: const Icon(Icons.add),
                  label: const Text("Enroll Subjects"),
                ),
              ],
            ),

            SizedBox(height: 10),

            ListenableBuilder(
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
                        children: enrollmentViewModel.enrollments.map((
                          enrollment,
                        ) {
                          return enrollmentCard(enrollment);
                        }).toList(),
                      );
              },
            ),
          ],
        ),
      ),
    );
  }
}
