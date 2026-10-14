// import 'package:flutter/material.dart';

// class StudentDetailsScreen extends StatelessWidget {
//   const StudentDetailsScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("Student Details")),
//       body: const Center(
//         child: Text("Student Details", style: TextStyle(fontSize: 18)),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import '../profile.dart';

class StudentDetailsScreen extends StatelessWidget {
  final Profile profile;

  const StudentDetailsScreen({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Student Details")),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            Center(child: Image.asset(profile.image, width: 150)),

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
                                decoration: const InputDecoration(
                                  labelText: "Favorite Subject",
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.zero,
                                  ),
                                ),
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
                            onPressed: () {},
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
