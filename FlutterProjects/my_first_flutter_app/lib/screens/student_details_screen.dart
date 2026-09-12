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
                        content: Text(
                          "Name: ${profile.name}\n"
                          "Student ID: ${profile.studentId}\n"
                          "Course: ${profile.course}\n"
                          "Year Level: ${profile.yearLevel}\n"
                          "Age: ${profile.age}\n"
                          "Hobby: ${profile.hobby}\n"
                          "Email: ${profile.email}\n"
                          "Favorite Subject: ${profile.favoriteSubject}\n"
                          "Scholar: ${profile.isScholar ? "Yes" : "No"}\n"
                          "Favorite: ${profile.isFavorite ? "Yes" : "No"}\n"
                          "Status: ${profile.active ? "Active" : "Inactive"}",
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text("Close"),
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
