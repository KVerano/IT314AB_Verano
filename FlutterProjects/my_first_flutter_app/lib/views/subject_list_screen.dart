import 'package:flutter/material.dart';
import '../models/subject.dart';
import '../viewmodels/subject_viewmodel.dart';
import 'edit_subject_dialog.dart';
import 'delete_subject_dialog.dart';
import 'side_menu.dart';

class SubjectListScreen extends StatefulWidget {
  const SubjectListScreen({super.key});

  @override
  State<SubjectListScreen> createState() => _SubjectListScreenState();
}

class _SubjectListScreenState extends State<SubjectListScreen> {
  String searchText = '';

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    await subjectViewModel.loadSubjects(
      showLoading: subjectViewModel.subjects.isEmpty,
    );

    if (!mounted) return;

    if (subjectViewModel.errorMessage != null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(subjectViewModel.errorMessage!)));
    }
  }

  List<Subject> get filteredSubjects {
    String text = searchText.trim().toLowerCase();

    return subjectViewModel.subjects.where((subject) {
      return subject.subject_code.toLowerCase().contains(text) ||
          subject.subject_name.toLowerCase().contains(text);
    }).toList();
  }

  Widget subjectCard(BuildContext context, Subject subject) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, '/subject-details', arguments: subject);
      },
      child: Card(
        elevation: 0,
        margin: EdgeInsets.zero,
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
      appBar: AppBar(
        title: const Text("DBTC Enrollment Management System"),
        automaticallyImplyLeading: false,
      ),
      body: Row(
        children: [
          const SideMenu(selected: 'subjects'),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Subjects",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(160, 40),
                        ),
                        onPressed: () async {
                          await Navigator.pushNamed(context, '/add-subject');
                        },
                        child: const Text("Add Subject"),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
                  child: TextField(
                    onChanged: (value) {
                      setState(() {
                        searchText = value;
                      });
                    },
                    decoration: const InputDecoration(
                      hintText: "Search by Subject Code or Name",
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                Expanded(
                  child: ListenableBuilder(
                    listenable: subjectViewModel,
                    builder: (context, child) {
                      List<Subject> subjects = filteredSubjects;

                      return subjectViewModel.isLoading
                          ? const Center(child: CircularProgressIndicator())
                          : subjects.isEmpty
                          ? const Center(
                              child: Text(
                                "No subjects found.",
                                style: TextStyle(fontSize: 18),
                              ),
                            )
                          : ListView.builder(
                              padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
                              itemCount: subjects.length,
                              itemBuilder: (context, index) {
                                return Column(
                                  children: [
                                    if (index == 0) SizedBox(height: 15),
                                    subjectCard(context, subjects[index]),
                                    SizedBox(height: 10),
                                  ],
                                );
                              },
                            );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
