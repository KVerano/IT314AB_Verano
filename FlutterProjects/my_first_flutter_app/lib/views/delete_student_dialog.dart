import 'package:flutter/material.dart';
import '../models/student.dart';

Future<bool> showDeleteStudentDialog(
  BuildContext context,
  Student student,
) async {
  final result = await showDialog<bool>(
    context: context,
    builder: (dialogContext) {
      return AlertDialog(
        title: const Text("Delete Student"),
        content: Text(
          "Are you sure you want to delete ${student.first_name} ${student.last_name}?",
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
