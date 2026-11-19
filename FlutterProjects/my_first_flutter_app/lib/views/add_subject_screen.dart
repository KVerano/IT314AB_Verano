import 'package:flutter/material.dart';
import '../models/subject.dart';
import '../viewmodels/subject_viewmodel.dart';
import 'side_menu.dart';

class AddSubjectScreen extends StatefulWidget {
  const AddSubjectScreen({super.key});

  @override
  State<AddSubjectScreen> createState() => _AddSubjectScreenState();
}

class _AddSubjectScreenState extends State<AddSubjectScreen> {
  final _formKey = GlobalKey<FormState>();

  final subjectCodeController = TextEditingController();
  final subjectNameController = TextEditingController();
  final unitsController = TextEditingController();
  final descriptionController = TextEditingController();

  @override
  void dispose() {
    subjectCodeController.dispose();
    subjectNameController.dispose();
    unitsController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SideMenu(selected: 'subjects'),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Add Subject",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      controller: subjectCodeController,
                      decoration: const InputDecoration(
                        labelText: "Subject Code",
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return "Please enter Subject Code";
                        }
                        if (subjectViewModel.subjects.any(
                          (subject) =>
                              subject.subject_code.trim().toLowerCase() ==
                              value.trim().toLowerCase(),
                        )) {
                          return "Subject code already exists";
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 15),
                    TextFormField(
                      controller: subjectNameController,
                      decoration: const InputDecoration(
                        labelText: "Subject Name",
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return "Please enter Subject Name";
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 15),
                    TextFormField(
                      controller: unitsController,
                      decoration: const InputDecoration(
                        labelText: "Units (1 to 6)",
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return "Please enter Units";
                        }
                        int? units = int.tryParse(value.trim());
                        if (units == null || units < 1 || units > 6) {
                          return "Units must be a number from 1 to 6";
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 15),
                    TextFormField(
                      controller: descriptionController,
                      decoration: const InputDecoration(
                        labelText: "Description (optional)",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(160, 40),
                          ),
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              Subject newSubject = Subject(
                                subject_code: subjectCodeController.text.trim(),
                                subject_name: subjectNameController.text.trim(),
                                units: int.parse(unitsController.text.trim()),
                                description:
                                    descriptionController.text.trim().isEmpty
                                    ? null
                                    : descriptionController.text.trim(),
                              );

                              bool saved = await subjectViewModel.addSubject(
                                newSubject,
                              );

                              if (!mounted) return;

                              if (!saved) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      subjectViewModel.errorMessage ??
                                          "Could not save subject",
                                    ),
                                  ),
                                );
                                return;
                              }

                              Navigator.pop(context, true);
                            }
                          },
                          child: const Text("Add Subject"),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
