import 'package:flutter/material.dart';
import '../profile.dart';
import '../student_records.dart';

class StudentListScreen extends StatefulWidget {
  const StudentListScreen({super.key});

  @override
  State<StudentListScreen> createState() => _StudentListScreenState();
}

class _StudentListScreenState extends State<StudentListScreen> {
  bool isLoading = false;

  Widget profileCard(BuildContext context, Profile profile) {
    return InkWell(
      onTap: () async {
        print("${profile.name} profile selected");

        await Navigator.pushNamed(
          context,
          '/student-details',
          arguments: profile,
        );

        if (!mounted) return;

        setState(() {});
      },
      child: Card(
        color: Colors.white.withOpacity(0.3),
        elevation: 0,
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Stack(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 50),
                  profile.image.isEmpty
                      ? Icon(Icons.person, size: 130, color: Colors.grey)
                      : Image.asset(profile.image, width: 130),
                  SizedBox(height: 30),
                  Text(
                    profile.name,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Text(
                    profile.course,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 18),
                  ),
                  SizedBox(height: 10),
                  Text(
                    profile.yearLevel,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 18),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Age: ${profile.age}",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 18),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Hobby: ${profile.hobby}",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 18),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Student ID: ${profile.studentId}",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 18),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Email: ${profile.email}",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 18),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Favorite Subject: ${profile.favoriteSubject}",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 18),
                  ),
                  SizedBox(height: 10),
                  Text(
                    profile.active ? "Active" : "Inactive",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 18),
                  ),
                  SizedBox(height: 20),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // scholar button
                      SizedBox(
                        width: 105,
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 6),
                          ),
                          onPressed: () async {
                            setState(() {
                              profile.isScholar = !profile.isScholar;
                            });

                            await saveProfiles();

                            if (!mounted) return;

                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  profile.isScholar
                                      ? "${profile.name} marked as Scholar"
                                      : "${profile.name} Scholar removed",
                                ),
                                duration: Duration(seconds: 1),
                              ),
                            );
                          },
                          icon: Icon(
                            profile.isScholar ? Icons.star : Icons.school,
                            size: 16,
                          ),
                          label: const Text(
                            "Scholar",
                            style: TextStyle(fontSize: 12),
                          ),
                        ),
                      ),

                      SizedBox(width: 5),

                      // edit button
                      SizedBox(
                        width: 105,
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 6),
                          ),
                          onPressed: () {
                            String editedName = profile.name;
                            String editedStudentId = profile.studentId;
                            String editedCourse = profile.course;
                            String editedYearLevel = profile.yearLevel;
                            String editedAge = profile.age.toString();
                            String editedHobby = profile.hobby;
                            String editedEmail = profile.email;
                            String editedFavoriteSubject =
                                profile.favoriteSubject;
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
                                            int.tryParse(editedAge.trim()) ==
                                                null) {
                                          ScaffoldMessenger.of(
                                            this.context,
                                          ).showSnackBar(
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
                                          ScaffoldMessenger.of(
                                            this.context,
                                          ).showSnackBar(
                                            const SnackBar(
                                              content: Text(
                                                "Student ID already exists",
                                              ),
                                            ),
                                          );
                                          return;
                                        }

                                        profile.name = editedName.trim();
                                        profile.studentId = editedStudentId
                                            .trim();
                                        profile.course = editedCourse.trim();
                                        profile.yearLevel = editedYearLevel
                                            .trim();
                                        profile.age = int.parse(
                                          editedAge.trim(),
                                        );
                                        profile.hobby = editedHobby.trim();
                                        profile.email = editedEmail.trim();
                                        profile.favoriteSubject =
                                            editedFavoriteSubject.trim();
                                        profile.active = editedActive;

                                        profiles.sort(
                                          (a, b) => a.name.compareTo(b.name),
                                        );

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
                          icon: const Icon(Icons.edit, size: 16),
                          label: const Text(
                            "Edit",
                            style: TextStyle(fontSize: 12),
                          ),
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
                            setState(() {
                              profiles.remove(profile);
                            });

                            await saveProfiles();

                            if (!mounted) return;

                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text("${profile.name} removed"),
                                duration: Duration(seconds: 1),
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
                  SizedBox(height: 30),
                ],
              ),

              Positioned(
                top: 0,
                right: 0,
                child: Column(
                  children: [
                    IconButton(
                      onPressed: () async {
                        setState(() {
                          profile.isFavorite = !profile.isFavorite;
                        });

                        await saveProfiles();
                      },
                      icon: Icon(
                        profile.isFavorite
                            ? Icons.favorite
                            : Icons.favorite_border,
                        color: Colors.deepPurple,
                        size: 28,
                      ),
                    ),

                    if (!profile.active)
                      Icon(Icons.warning, size: 28, color: Colors.deepPurple),
                  ],
                ),
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
        title: const Text("My First Flutter Application"),
        actions: [
          IconButton(
            onPressed: () async {
              final result = await Navigator.pushNamed(context, '/add-student');

              if (result == true) {
                setState(() {});
              }
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : profiles.isEmpty
          ? const Center(
              child: Text("No students found.", style: TextStyle(fontSize: 18)),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: profiles.length,
              itemBuilder: (context, index) {
                return profileCard(context, profiles[index]);
              },
            ),
    );
  }
}
