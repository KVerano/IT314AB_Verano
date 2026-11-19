import 'package:flutter/material.dart';
import '../models/enrollment_detail.dart';

Future<bool> showDropEnrollmentDialog(
  BuildContext context,
  EnrollmentDetail enrollment,
) async {
  final result = await showDialog<bool>(
    context: context,
    builder: (dialogContext) {
      return AlertDialog(
        title: const Text("Drop Enrollment"),
        content: Text(
          "Are you sure you want to drop ${enrollment.subject_code}?",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text("Drop"),
          ),
        ],
      );
    },
  );

  return result ?? false;
}
