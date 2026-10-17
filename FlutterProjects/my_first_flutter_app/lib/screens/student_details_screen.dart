import 'package:flutter/material.dart';
import '../profile.dart';
import '../student_records.dart';

class StudentDetailsScreen extends StatefulWidget {
  final Profile profile;

  const StudentDetailsScreen({super.key, required this.profile});

  @override
  State<StudentDetailsScreen> createState() => _StudentDetailsScreenState();
}

class _StudentDetailsScreenState extends State<StudentDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    final profile = widget.profile;

    return Scaffold(
      appBar: AppBar(title: const Text("Student Details")),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            Center(
              child: profile.image.isEmpty
                  ? const Icon(Icons.person, size: 150, color: Colors.grey)
                  : Image.asset(profile.image, width: 150),
            ),

            SizedBox(height: 50),

            Text("Name: ${profile.name}", style: TextStyle(fontSize: 18)),

            SizedBox(height: 10),

            Text(
              "Student ID: ${profile.studentId}",
              style: TextStyle(fontSize: 18),
            ),

            SizedBox(height: 10),

            Text("Course: ${profile.course}", style: TextStyle(fontSize: 18)),

            SizedBox(height: 10),

            Text(
              "Year Level: ${profile.yearLevel}",
              style: TextStyle(fontSize: 18),
            ),

            SizedBox(height: 10),

            Text("Age: ${profile.age}", style: TextStyle(fontSize: 18)),

            SizedBox(height: 10),

            Text("Hobby: ${profile.hobby}", style: TextStyle(fontSize: 18)),

            SizedBox(height: 10),

            Text("Email: ${profile.email}", style: TextStyle(fontSize: 18)),

            SizedBox(height: 10),

            Text(
              "Favorite Subject: ${profile.favoriteSubject}",
              style: TextStyle(fontSize: 18),
            ),

            SizedBox(height: 10),

            Text(
              profile.isScholar ? "Scholar: Yes" : "Scholar: No",
              style: TextStyle(fontSize: 18),
            ),

            SizedBox(height: 10),

            Text(
              profile.isFavorite ? "Favorite: Yes" : "Favorite: No",
              style: TextStyle(fontSize: 18),
            ),

            SizedBox(height: 10),

            Text(
              profile.active ? "Status: Active" : "Status: Inactive",
              style: TextStyle(fontSize: 18),
            ),

            SizedBox(height: 50),

            Center(
              child: ElevatedButton.icon(
                onPressed: () {
                  String editedName = profile.name;
                  String editedStudentId = profile.studentId;
                  String editedCourse = profile.course;
                  String editedYearLevel = profile.yearLevel;
                  String editedAge = profile.age.toString();
                  String editedHobby = profile.hobby;
                  String editedEmail = profile.email;
                  String editedFavoriteSubject = profile.favoriteSubject;
                  bool editedActive = profile.active;

                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text("Edit ${profile.name}"),
                        content: SingleChildScrollView(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              TextFormField(
                                initialValue: profile.name,
                                onChanged: (value) {
                                  editedName = value;
                                },
                                decoration: const InputDecoration(
                                  labelText: "Name",
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.zero,
                                  ),
                                ),
                              ),
                              SizedBox(height: 10),
                              TextFormField(
                                initialValue: profile.studentId,
                                onChanged: (value) {
                                  editedStudentId = value;
                                },
                                decoration: const InputDecoration(
                                  labelText: "Student ID",
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.zero,
                                  ),
                                ),
                              ),
                              SizedBox(height: 10),
                              TextFormField(
                                initialValue: profile.course,
                                onChanged: (value) {
                                  editedCourse = value;
                                },
                                decoration: const InputDecoration(
                                  labelText: "Course",
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.zero,
                                  ),
                                ),
                              ),
                              SizedBox(height: 10),
                              TextFormField(
                                initialValue: profile.yearLevel,
                                onChanged: (value) {
                                  editedYearLevel = value;
                                },
                                decoration: const InputDecoration(
                                  labelText: "Year Level",
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.zero,
                                  ),
                                ),
                              ),
                              SizedBox(height: 10),
                              TextFormField(
                                initialValue: profile.age.toString(),
                                onChanged: (value) {
                                  editedAge = value;
                                },
                                decoration: const InputDecoration(
                                  labelText: "Age",
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.zero,
                                  ),
                                ),
                                keyboardType: TextInputType.number,
                              ),
                              SizedBox(height: 10),
                              TextFormField(
                                initialValue: profile.hobby,
                                onChanged: (value) {
                                  editedHobby = value;
                                },
                                decoration: const InputDecoration(
                                  labelText: "Hobby",
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.zero,
                                  ),
                                ),
                              ),
                              SizedBox(height: 10),
                              TextFormField(
                                initialValue: profile.email,
                                onChanged: (value) {
                                  editedEmail = value;
                                },
                                decoration: const InputDecoration(
                                  labelText: "Email",
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.zero,
                                  ),
                                ),
                              ),
                              SizedBox(height: 10),
                              TextFormField(
                                initialValue: profile.favoriteSubject,
                                onChanged: (value) {
                                  editedFavoriteSubject = value;
                                },
                                decoration: const InputDecoration(
                                  labelText: "Favorite Subject",
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.zero,
                                  ),
                                ),
                              ),
                              SizedBox(height: 10),
                              StatefulBuilder(
                                builder: (context, setDialogState) {
                                  return SwitchListTile(
                                    title: const Text("Active"),
                                    value: editedActive,
                                    onChanged: (value) {
                                      setDialogState(() {
                                        editedActive = value;
                                      });
                                    },
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text("Cancel"),
                          ),
                          ElevatedButton(
                            onPressed: () async {
                              if (editedName.trim().isEmpty ||
                                  editedStudentId.trim().isEmpty ||
                                  editedCourse.trim().isEmpty ||
                                  editedYearLevel.trim().isEmpty ||
                                  editedEmail.trim().isEmpty ||
                                  editedAge.trim().isEmpty ||
                                  int.tryParse(editedAge.trim()) == null) {
                                ScaffoldMessenger.of(this.context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      "Please enter valid student information",
                                    ),
                                  ),
                                );
                                return;
                              }

                              bool duplicateId = profiles.any(
                                (student) =>
                                    student != profile &&
                                    student.studentId.trim() ==
                                        editedStudentId.trim(),
                              );

                              if (duplicateId) {
                                ScaffoldMessenger.of(this.context).showSnackBar(
                                  const SnackBar(
                                    content: Text("Student ID already exists"),
                                  ),
                                );
                                return;
                              }

                              profile.name = editedName.trim();
                              profile.studentId = editedStudentId.trim();
                              profile.course = editedCourse.trim();
                              profile.yearLevel = editedYearLevel.trim();
                              profile.age = int.parse(editedAge.trim());
                              profile.hobby = editedHobby.trim();
                              profile.email = editedEmail.trim();
                              profile.favoriteSubject = editedFavoriteSubject
                                  .trim();
                              profile.active = editedActive;

                              profiles.sort((a, b) => a.name.compareTo(b.name));

                              await saveProfiles();

                              if (!mounted) return;

                              Navigator.pop(this.context);

                              setState(() {});
                            },
                            child: const Text("Save"),
                          ),
                        ],
                      );
                    },
                  );
                },
                icon: const Icon(Icons.edit),
                label: const Text("Edit"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
