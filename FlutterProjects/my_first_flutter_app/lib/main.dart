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
    email: 'cassandra oraiz@dbtc-cebu.edu.ph',
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

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  Widget profileCard(Profile profile) {
    return Card(
      color: Colors.white.withOpacity(0.3),
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
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
            SizedBox(height: 50),
          ],
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
                  return profileCard(profiles[index]);
                },
              ),
      ),
    );
  }
}