import 'package:flutter/material.dart';
import '../core/time_helper.dart';
import '../models/schedule.dart';

Future<bool> showDeleteScheduleDialog(
  BuildContext context,
  Schedule schedule,
) async {
  final result = await showDialog<bool>(
    context: context,
    builder: (dialogContext) {
      return AlertDialog(
        title: const Text("Delete Schedule"),
        content: Text(
          "Are you sure you want to delete this schedule "
          "(${schedule.day_of_week} ${formatTime12Hour(schedule.start_time)} - ${formatTime12Hour(schedule.end_time)})?",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text("Delete"),
          ),
        ],
      );
    },
  );

  return result ?? false;
}
