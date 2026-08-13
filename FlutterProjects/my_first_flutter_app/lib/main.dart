import 'package:flutter/material.dart';

String profileImage = 'assets/kierstien.jpeg';
String appTitle = "My First Flutter Application";
String name = "Verano, Kierstien S.";
String courseSection = "BSIT-3";
String birthdate = "May 15, 2006";
int age = 20;
String hobby = "Sleeping";
double height = 160.0;
bool isStudent = true;

class Profile {
  String? image;
  String? name;
  String? courseSection;
  int? age;
  String? hobby;

  Profile({this.image, this.name, this.courseSection, this.age, this.hobby});
}

List<Profile> profiles = [
  Profile(
    image: 'assets/kierstien.jpeg',
    name: 'Verano, Kierstien S.',
    courseSection: 'BSIT-3',
    age: 20,
    hobby: 'Sleeping',
  ),

  Profile(
    image: 'assets/kyla.jpeg',
    name: 'Caballero, Kyla Marie S.',
    courseSection: null,
    age: 20,
    hobby: 'Drawing',
  ),

  Profile(
    image: 'assets/zelon.jpeg',
    name: 'Estimo, Zelon Matthew C.',
    courseSection: 'BSIT-3',
    age: null,
    hobby: 'Dancing',
  ),

  Profile(
    image: 'assets/leila.jpeg',
    name: 'Bangoy, Leila G.',
    courseSection: 'BSIT-3',
    age: 20,
    hobby: null,
  ),

  Profile(
    image: 'assets/cassy.jpeg',
    name: 'Oraiz, Cassandra Gayle R.',
    courseSection: 'BSIT-3',
    age: 20,
    hobby: 'Gaming',
  ),
];

void main() {
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

            Image.asset(profile.image ?? 'Missing', width: 130),

            SizedBox(height: 30),

            Text(
              profile.name ?? 'Missing',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),

            SizedBox(height: 10),

            Text(
              profile.courseSection ?? 'Missing',
              style: TextStyle(fontSize: 18),
            ),

            SizedBox(height: 10),

            Text(
              "Age: ${profile.age ?? 'Missing'}",
              style: TextStyle(fontSize: 18),
            ),

            SizedBox(height: 10),

            Text(
              "Hobby: ${profile.hobby ?? 'Missing'}",
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
        body: SingleChildScrollView(
          // provides scrolling capability to a single child container whose content might exceed the available screen space (Flag 6)
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                for (Profile profile in profiles) profileCard(profile),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
