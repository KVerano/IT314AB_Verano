import 'package:flutter/material.dart';
import '../models/subject.dart';
import '../viewmodels/subject_viewmodel.dart';
import 'edit_subject_dialog.dart';
import 'delete_subject_dialog.dart';

class SubjectListScreen extends StatefulWidget {
  const SubjectListScreen({super.key});

  @override
  State<SubjectListScreen> createState() => _SubjectListScreenState();
}

class _SubjectListScreenState extends State<SubjectListScreen> {
  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    await subjectViewModel.loadSubjects();

    if (!mounted) return;

    if (subjectViewModel.errorMessage != null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(subjectViewModel.errorMessage!)));
    }
  }

  Widget subjectCard(BuildContext context, Subject subject) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, '/subject-details', arguments: subject);
      },
      child: Card(
        color: Colors.white.withValues(alpha: 0.3),
        elevation: 0,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Text(
                subject.subject_code,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                subject.subject_name,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 10),
              Text(
                "Units: ${subject.units}",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18),
              ),
              if (subject.description != null &&
                  subject.description!.isNotEmpty) ...[
                SizedBox(height: 10),
                Text(
                  subject.description!,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16),
                ),
              ],
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
                        showEditSubjectDialog(context, subject);
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
                        bool confirmed = await showDeleteSubjectDialog(
                          context,
                          subject,
                        );

                        if (!confirmed) return;

                        bool deleted = await subjectViewModel.deleteSubject(
                          subject,
                        );

                        if (!mounted) return;

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              deleted
                                  ? "${subject.subject_code} removed"
                                  : subjectViewModel.errorMessage ??
                                        "Could not delete subject",
                            ),
                            duration: Duration(seconds: 2),
                          ),
                        );
                      },
                      icon: const Icon(Icons.delete, size: 16),
                      label: const Text(
                        "Delete",
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 231, 227, 227),
      appBar: AppBar(
        title: const Text("Subjects"),
        actions: [
          IconButton(
            onPressed: () async {
              await Navigator.pushNamed(context, '/add-subject');
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: ListenableBuilder(
        listenable: subjectViewModel,
        builder: (context, child) {
          return subjectViewModel.isLoading
              ? const Center(child: CircularProgressIndicator())
              : subjectViewModel.subjects.isEmpty
              ? const Center(
                  child: Text(
                    "No subjects found.",
                    style: TextStyle(fontSize: 18),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(8),
                  itemCount: subjectViewModel.subjects.length,
                  itemBuilder: (context, index) {
                    return subjectCard(
                      context,
                      subjectViewModel.subjects[index],
                    );
                  },
                );
        },
      ),
    );
  }
}
