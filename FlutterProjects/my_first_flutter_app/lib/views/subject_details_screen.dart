import 'package:flutter/material.dart';
import '../models/schedule.dart';
import '../models/subject.dart';
import '../viewmodels/schedule_viewmodel.dart';
import 'add_edit_schedule_screen.dart';
import 'delete_schedule_dialog.dart';
import '../core/time_helper.dart';

class SubjectDetailsScreen extends StatefulWidget {
  final Subject subject;

  const SubjectDetailsScreen({super.key, required this.subject});

  @override
  State<SubjectDetailsScreen> createState() => _SubjectDetailsScreenState();
}

class _SubjectDetailsScreenState extends State<SubjectDetailsScreen> {
  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    await scheduleViewModel.loadSchedules(widget.subject.subject_id!);

    if (!mounted) return;

    if (scheduleViewModel.errorMessage != null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(scheduleViewModel.errorMessage!)));
    }
  }

  void openForm(Schedule? schedule) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return AddEditScheduleScreen(
            subject: widget.subject,
            schedule: schedule,
          );
        },
      ),
    );
  }

  Widget scheduleCard(Schedule schedule) {
    return Card(
      color: Colors.white.withValues(alpha: 0.3),
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              schedule.day_of_week,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              "${formatTime12Hour(schedule.start_time)} - ${formatTime12Hour(schedule.end_time)}",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 10),
            Text(
              "Room: ${schedule.room}",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 10),
            Text(
              "Slot Capacity: ${schedule.slot_capacity}",
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
                      openForm(schedule);
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
                      bool confirmed = await showDeleteScheduleDialog(
                        context,
                        schedule,
                      );

                      if (!confirmed) return;

                      bool deleted = await scheduleViewModel.deleteSchedule(
                        schedule,
                      );

                      if (!mounted) return;

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            deleted
                                ? "Schedule removed"
                                : scheduleViewModel.errorMessage ??
                                      "Could not delete schedule",
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

  @override
  Widget build(BuildContext context) {
    final subject = widget.subject;

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 231, 227, 227),
      appBar: AppBar(
        title: const Text("Subject Details"),
        actions: [
          IconButton(
            onPressed: () {
              openForm(null);
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Subject Code: ${subject.subject_code}",
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 10),
            Text(
              "Subject Name: ${subject.subject_name}",
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 10),
            Text("Units: ${subject.units}", style: TextStyle(fontSize: 18)),
            if (subject.description != null &&
                subject.description!.isNotEmpty) ...[
              SizedBox(height: 10),
              Text(
                "Description: ${subject.description}",
                style: TextStyle(fontSize: 18),
              ),
            ],
            SizedBox(height: 20),
            Text(
              "Schedules",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Expanded(
              child: ListenableBuilder(
                listenable: scheduleViewModel,
                builder: (context, child) {
                  return scheduleViewModel.isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : scheduleViewModel.schedules.isEmpty
                      ? const Center(
                          child: Text(
                            "No schedules yet. Tap + to add one.",
                            style: TextStyle(fontSize: 16),
                          ),
                        )
                      : ListView.builder(
                          itemCount: scheduleViewModel.schedules.length,
                          itemBuilder: (context, index) {
                            return scheduleCard(
                              scheduleViewModel.schedules[index],
                            );
                          },
                        );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
