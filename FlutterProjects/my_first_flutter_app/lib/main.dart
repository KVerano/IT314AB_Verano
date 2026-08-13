import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: const Color(0xFFFFE6EE),
        appBar: AppBar(title: const Text("My First Flutter Application")),
        body: SingleChildScrollView(
          // provides scrolling capability to a single child container whose content might exceed the available screen space
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Card 1: Personal Information (Profile kemeru of mine)
                Card(
                  color: Colors.white.withOpacity(0.3),
                  elevation: 0,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset('assets/dachshund.png', width: 130),

                        SizedBox(height: 10),
                        Text(
                          "Verano, Kierstien S.",
                          style: TextStyle(
                            fontSize: 23,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        SizedBox(height: 10),
                        Text("BSIT-3", style: TextStyle(fontSize: 18)),

                        SizedBox(height: 10),
                        Text(
                          "My First Flutter Application",
                          style: TextStyle(
                            fontSize: 23,
                            fontStyle: FontStyle.italic,
                          ),
                        ),

                        SizedBox(height: 10),
                        Text(
                          "August 11, 2026",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        SizedBox(height: 10),
                        Text("Hobby: Sleeping", style: TextStyle(fontSize: 23)),

                        SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text('Age: 20', style: TextStyle(fontSize: 16)),

                            SizedBox(width: 30),
                            Text(
                              'Birthdate: May 15, 2006',
                              style: TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                SizedBox(height: 20),

                // Card 2: Favorites of mine <33
                Card(
                  color: Colors.white.withOpacity(0.3),
                  elevation: 0,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(Icons.favorite, size: 22),

                            SizedBox(width: 8),
                            Text(
                              "My Favorites",
                              style: TextStyle(
                                fontSize: 23,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            SizedBox(width: 8),
                            Icon(Icons.favorite, size: 22),
                          ],
                        ),

                        SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'Game: Mobile Legends',
                              style: TextStyle(fontSize: 16),
                            ),

                            SizedBox(width: 15),
                            Text(
                              'Movie: Mean Girls',
                              style: TextStyle(fontSize: 16),
                            ),
                          ],
                        ),

                        SizedBox(height: 10),
                        Text("Color: Pink", style: TextStyle(fontSize: 15)),
                      ],
                    ),
                  ),
                ),

                SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/*class _InfoBox extends StatelessWidget {
  final String text;
  final double fontSize;
  final FontWeight fontWeight;

  const _InfoBox({
    required this.text,
    required this.fontSize,
    this.fontWeight = FontWeight.normal,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Color.fromARGB(90, 255, 255, 255),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: fontSize,
          fontWeight: fontWeight,
          color: const Color.fromARGB(255, 255, 176, 210),
        ),
      ),
    );
  }
}*/
