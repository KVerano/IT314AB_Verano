import 'package:flutter/material.dart';
import '../core/time_helper.dart';
import '../models/enrollment_detail.dart';
import '../viewmodels/enrollment_viewmodel.dart';
import '../viewmodels/schedule_viewmodel.dart';

Future<bool> showChangeScheduleDialog(
  BuildContext context,
  EnrollmentDetail enrollment,
) async {
  await scheduleViewModel.loadSchedules(
    enrollment.subject_id,
    showLoading: false,
  );

  if (!context.mounted) return false;

  if (scheduleViewModel.errorMessage != null) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(scheduleViewModel.errorMessage!)));
    return false;
  }

  final otherSchedules = scheduleViewModel.schedules
      .where(
        (schedule) =>
            schedule.subject_id == enrollment.subject_id &&
            schedule.schedule_id != enrollment.schedule_id,
      )
      .toList();

  int? selectedScheduleId;

  final result = await showDialog<bool>(
    context: context,
    builder: (dialogContext) {
      return AlertDialog(
        title: Text("Change Schedule (${enrollment.subject_code})"),
        content: otherSchedules.isEmpty
            ? const Text("This subject has no other schedule.")
            : SizedBox(
                width: 300,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    DropdownButtonFormField<int>(
                      isExpanded: true,
                      decoration: const InputDecoration(
                        labelText: "New Schedule",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.zero,
                        ),
                      ),
                      items: otherSchedules.map((schedule) {
                        return DropdownMenuItem<int>(
                          value: schedule.schedule_id!,
                          child: Text(
                            "${schedule.day_of_week}, ${formatTime12Hour(schedule.start_time)} - ${formatTime12Hour(schedule.end_time)} (${schedule.room})",
                            overflow: TextOverflow.ellipsis,
                          ),
                        );
                      }).toList(),
                      onChanged: (value) {
                        selectedScheduleId = value;
                      },
                    ),
                  ],
                ),
              ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text("Cancel"),
          ),
          if (otherSchedules.isNotEmpty)
            ElevatedButton(
              onPressed: () async {
                if (selectedScheduleId == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Please select a Schedule")),
                  );
                  return;
                }

                bool saved = await enrollmentViewModel.changeSchedule(
                  enrollment,
                  selectedScheduleId!,
                );

                if (!context.mounted) return;

                if (!saved) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        enrollmentViewModel.errorMessage ??
                            "Could not change schedule",
                      ),
                    ),
                  );
                  return;
                }

                if (!dialogContext.mounted) return;

                Navigator.pop(dialogContext, true);
              },
              child: const Text("Save"),
            ),
        ],
      );
    },
  );

  return result ?? false;
}
