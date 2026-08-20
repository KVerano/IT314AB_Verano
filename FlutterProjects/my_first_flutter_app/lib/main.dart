import 'package:flutter/material.dart';

// String profileImage = 'assets/kierstien.jpeg';
// String appTitle = "My First Flutter Application";
// String name = "Verano, Kierstien S.";
// String courseSection = "BSIT-3";
// String birthdate = "May 15, 2006";
// int age = 20;
// String hobby = "Sleeping";
// double height = 160.0;
// bool isStudent = true;

class Profile {
  String image;
  String name;
  String course;
  String yearLevel;
  int age;
  String hobby;
  String studentId;
  String email;
  String favoriteSubject;
  bool isScholar = false;
  bool isFavorite = false;

  Profile({
    required this.image,
    required this.name,
    required this.course,
    required this.yearLevel,
    required this.age,
    required this.hobby,
    required this.studentId,
    required this.email,
    required this.favoriteSubject,
  });
}

List<Profile> profiles = [
  Profile(
    image: 'assets/kierstien.jpeg',
    name: 'Verano, Kierstien S.',
    course: 'BSIT',
    yearLevel: '3rd Year',
    age: 20,
    hobby: 'Sleeping',
    studentId: '11111',
    email: 'kierstien.verano@dbtc-cebu.edu.ph',
    favoriteSubject: 'Break Time',
  ),

  Profile(
    image: 'assets/kyla.jpeg',
    name: 'Caballero, Kyla Marie S.',
    course: 'BSIT',
    yearLevel: '3rd Year',
    age: 20,
    hobby: 'Drawing',
    studentId: '22222',
    email: 'kyla.caballero@dbtc-cebu.edu.ph',
    favoriteSubject: 'Break Time',
  ),

  Profile(
    image: 'assets/zelon.jpeg',
    name: 'Estimo, Zelon Matthew C.',
    course: 'BSIT',
    yearLevel: '3rd Year',
    age: 21,
    hobby: 'Dancing',
    studentId: '33333',
    email: 'zelon.estimo@dbtc-cebu.edu.ph',
    favoriteSubject: 'Dismissal Time',
  ),

  Profile(
    image: 'assets/leila.jpeg',
    name: 'Bangoy, Leila G.',
    course: 'BSIT',
    yearLevel: '3rd Year',
    age: 20,
    hobby: 'Watching Movies',
    studentId: '44444',
    email: 'leila.bangoy@dbtc-cebu.edu.ph',
    favoriteSubject: 'Application Development and Emerging Technologies',
  ),

  Profile(
    image: 'assets/cassy.jpeg',
    name: 'Oraiz, Cassandra Gayle R.',
    course: 'BSIT',
    yearLevel: '3rd Year',
    age: 20,
    hobby: 'Gaming',
    studentId: '55555',
    email: 'cassandra.oraiz@dbtc-cebu.edu.ph',
    favoriteSubject: 'Internet of Things',
  ),

  Profile(
    image: 'assets/taylor.webp',
    name: 'Swift, Taylor Alison',
    course: 'BSIT',
    yearLevel: '3rd Year',
    age: 23,
    hobby: 'Singing',
    studentId: '66666',
    email: 'taylor.swift@dbtc-cebu.edu.ph',
    favoriteSubject: 'Fundamentals of Databased System',
  ),
];

void main() {
  profiles.sort((a, b) => a.name.compareTo(b.name));
  // ma'am ako gi sort lang by surname instead sa first name since sa akong profile ga una ang mga surnames. thank you
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Widget profileCard(BuildContext context, Profile profile) {
    return InkWell(
      onTap: () {
        print("${profile.name} profile selected");

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("${profile.name} profile selected"),
            duration: Duration(seconds: 1),
          ),
        );
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
                                  content: const Text("Hello! Edit form coming soon pa eme."),
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
                child: IconButton(
                  onPressed: () {
                    setState(() {
                      profile.isFavorite = !profile.isFavorite;
                    });
                  },
                  icon: Icon(
                    profile.isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: Colors.deepPurple,
                    size: 28,
                  ),
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
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: const Color.fromARGB(255, 231, 227, 227),
        appBar: AppBar(title: const Text("My First Flutter Application")),
        body: profiles.isEmpty
            ? const Center(
                child: Text(
                  "No students found.",
                  style: TextStyle(fontSize: 18),
                ),
              )
            : ListView.builder(
                padding: const EdgeInsets.all(8),
                itemCount: profiles.length,
                itemBuilder: (context, index) {
                  return profileCard(context, profiles[index]);
                },
              ),
      ),
    );
  }
}
