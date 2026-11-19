import 'package:flutter/material.dart';
import '../models/grade_detail.dart';

Future<bool> showDeleteGradeDialog(
  BuildContext context,
  GradeDetail grade,
) async {
  final result = await showDialog<bool>(
    context: context,
    builder: (dialogContext) {
      return AlertDialog(
        title: const Text("Delete Grade"),
        content: Text(
          "Are you sure you want to delete the grade for ${grade.subject_code}?",
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
