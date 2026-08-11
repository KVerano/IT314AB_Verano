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
        appBar: AppBar(
          title: const Text("My First Flutter Application"),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/dachshund.png',
                width: 150,
              ),
              SizedBox(height: 20),

              _InfoBox(
                text: "Verano, Kierstien S.",
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              SizedBox(height: 10),

              _InfoBox(
                text: "BSIT-3",
                fontSize: 20,
              ),
              SizedBox(height: 10),

              _InfoBox(
                text: "My First Flutter Application",
                fontSize: 20,
              ),
              SizedBox(height: 10),

              _InfoBox(
                text: "August 4, 2026",
                fontSize: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoBox extends StatelessWidget {
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
}