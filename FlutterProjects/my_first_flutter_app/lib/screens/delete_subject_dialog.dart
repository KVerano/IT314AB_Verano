import 'package:flutter/material.dart';
import '../models/subject.dart';

Future<bool> showDeleteSubjectDialog(
  BuildContext context,
  Subject subject,
) async {
  final result = await showDialog<bool>(
    context: context,
    builder: (dialogContext) {
      return AlertDialog(
        title: const Text("Delete Subject"),
        content: Text(
          "Are you sure you want to delete ${subject.subject_code}? "
          "Its schedules will also be deleted.",
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
