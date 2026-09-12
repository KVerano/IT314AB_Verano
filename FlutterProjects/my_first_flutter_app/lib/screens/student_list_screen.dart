import 'package:flutter/material.dart';
import '../profile.dart';

class StudentListScreen extends StatefulWidget {
  const StudentListScreen({super.key});

  @override
  State<StudentListScreen> createState() => _StudentListScreenState();
}

class _StudentListScreenState extends State<StudentListScreen> {
  bool isLoading = false;

  Widget profileCard(BuildContext context, Profile profile) {
    return InkWell(
      onTap: () {
        print("${profile.name} profile selected");

        Navigator.pushNamed(context, '/student-details', arguments: profile);
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
                  Image.asset(profile.image, width: 130),
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
                          onPressed: () {
                            setState(() {
                              profile.isScholar = !profile.isScholar;
                            });

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
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: Text("Edit ${profile.name}"),
                                  content: const Text(
                                    "Hello! Edit form coming soon pa eme.",
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
                          onPressed: () {
                            setState(() {
                              profiles.remove(profile);
                            });

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
                      onPressed: () {
                        setState(() {
                          profile.isFavorite = !profile.isFavorite;
                        });
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
            onPressed: () {
              Navigator.pushNamed(context, '/add-student');
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
