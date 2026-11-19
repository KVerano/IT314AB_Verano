import 'package:flutter/material.dart';
import '../models/grade.dart';
import '../models/grade_detail.dart';
import '../viewmodels/grade_viewmodel.dart';

Future<bool> showEditGradeDialog(
  BuildContext context,
  GradeDetail grade,
) async {
  String editedValue = grade.grade_value.toString();
  String editedRemarks = grade.remarks ?? '';

  final result = await showDialog<bool>(
    context: context,
    builder: (dialogContext) {
      return AlertDialog(
        title: Text("Edit Grade (${grade.subject_code})"),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                initialValue: grade.grade_value.toString(),
                onChanged: (value) {
                  editedValue = value;
                },
                decoration: const InputDecoration(
                  labelText: "Grade Value (0 to 100)",
                  border: OutlineInputBorder(borderRadius: BorderRadius.zero),
                ),
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
              ),
              SizedBox(height: 10),
              TextFormField(
                initialValue: grade.remarks ?? '',
                onChanged: (value) {
                  editedRemarks = value;
                },
                decoration: const InputDecoration(
                  labelText: "Remarks (optional)",
                  border: OutlineInputBorder(borderRadius: BorderRadius.zero),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () async {
              double? value = double.tryParse(editedValue.trim());

              if (value == null || value < 0 || value > 100) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Grade must be a number from 0 to 100"),
                  ),
                );
                return;
              }

              Grade updatedGrade = Grade(
                grade_id: grade.grade_id,
                enrollment_id: grade.enrollment_id,
                grade_value: value,
                remarks: editedRemarks.trim().isEmpty
                    ? null
                    : editedRemarks.trim(),
              );

              bool saved = await gradeViewModel.updateGrade(
                updatedGrade,
                grade.student_id,
              );

              if (!context.mounted) return;

              if (!saved) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      gradeViewModel.errorMessage ?? "Could not save",
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
