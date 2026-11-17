import 'package:flutter/material.dart';
import '../models/subject.dart';
import '../viewmodels/subject_viewmodel.dart';

Future<Subject?> showEditSubjectDialog(BuildContext context, Subject subject) {
  String editedCode = subject.subject_code;
  String editedName = subject.subject_name;
  String editedUnits = subject.units.toString();
  String editedDescription = subject.description ?? '';

  return showDialog<Subject>(
    context: context,
    builder: (dialogContext) {
      return AlertDialog(
        title: Text("Edit ${subject.subject_code}"),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                initialValue: subject.subject_code,
                onChanged: (value) {
                  editedCode = value;
                },
                decoration: const InputDecoration(
                  labelText: "Subject Code",
                  border: OutlineInputBorder(borderRadius: BorderRadius.zero),
                ),
              ),
              SizedBox(height: 10),
              TextFormField(
                initialValue: subject.subject_name,
                onChanged: (value) {
                  editedName = value;
                },
                decoration: const InputDecoration(
                  labelText: "Subject Name",
                  border: OutlineInputBorder(borderRadius: BorderRadius.zero),
                ),
              ),
              SizedBox(height: 10),
              TextFormField(
                initialValue: subject.units.toString(),
                onChanged: (value) {
                  editedUnits = value;
                },
                decoration: const InputDecoration(
                  labelText: "Units (1 to 6)",
                  border: OutlineInputBorder(borderRadius: BorderRadius.zero),
                ),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 10),
              TextFormField(
                initialValue: subject.description ?? '',
                onChanged: (value) {
                  editedDescription = value;
                },
                decoration: const InputDecoration(
                  labelText: "Description (optional)",
                  border: OutlineInputBorder(borderRadius: BorderRadius.zero),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () async {
              int? units = int.tryParse(editedUnits.trim());

              if (editedCode.trim().isEmpty ||
                  editedName.trim().isEmpty ||
                  units == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Please enter valid subject information"),
                  ),
                );
                return;
              }

              if (units < 1 || units > 6) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Units must be from 1 to 6")),
                );
                return;
              }

              bool duplicateCode = subjectViewModel.subjects.any(
                (other) =>
                    other.subject_id != subject.subject_id &&
                    other.subject_code.trim().toLowerCase() ==
                        editedCode.trim().toLowerCase(),
              );

              if (duplicateCode) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Subject code already exists")),
                );
                return;
              }

              Subject updatedSubject = Subject(
                subject_id: subject.subject_id,
                subject_code: editedCode.trim(),
                subject_name: editedName.trim(),
                units: units,
                description: editedDescription.trim().isEmpty
                    ? null
                    : editedDescription.trim(),
              );

              bool saved = await subjectViewModel.updateSubject(updatedSubject);

              if (!context.mounted) return;

              if (!saved) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      subjectViewModel.errorMessage ?? "Could not save",
                    ),
                  ),
                );
                return;
              }

              if (!dialogContext.mounted) return;

              Navigator.pop(dialogContext, updatedSubject);
            },
            child: const Text("Save"),
          ),
        ],
      );
    },
  );
}
