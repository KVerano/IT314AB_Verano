import 'package:flutter/material.dart';

class SideMenu extends StatelessWidget {
  final String selected;

  const SideMenu({super.key, required this.selected});

  Widget menuItem(
    IconData icon,
    String text,
    bool isSelected,
    VoidCallback onTap,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
      child: ListTile(
        tileColor: isSelected ? const Color(0xFF0066CC) : null,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        leading: Icon(icon, color: Colors.white, size: 22),
        title: Text(
          text,
          style: const TextStyle(color: Colors.white, fontSize: 16),
        ),
        onTap: onTap,
      ),
    );
  }

  void openPage(BuildContext context, String name, String route) {
    if (selected == name) return;

    Navigator.pushNamedAndRemoveUntil(
      context,
      route,
      ModalRoute.withName('/student-list'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xFF003366),
      child: SizedBox(
        width: 220,
        child: Column(
          children: [
            SizedBox(height: 20),
            menuItem(Icons.school, "Students", selected == 'students', () {
              if (selected != 'students') {
                Navigator.popUntil(
                  context,
                  ModalRoute.withName('/student-list'),
                );
              }
            }),
            menuItem(Icons.menu_book, "Subjects", selected == 'subjects', () {
              openPage(context, 'subjects', '/subject-list');
            }),
            menuItem(Icons.schedule, "Schedules", selected == 'schedules', () {
              openPage(context, 'schedules', '/add-schedule');
            }),
            menuItem(
              Icons.how_to_reg,
              "Enrollments",
              selected == 'enrollments',
              () {
                openPage(context, 'enrollments', '/enroll-student');
              },
            ),
            menuItem(Icons.grading, "Grades", selected == 'grades', () {
              openPage(context, 'grades', '/add-grade');
            }),

            Spacer(),

            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Image.asset(
                'assets/db_logo.png',
                width: 130,
                fit: BoxFit.contain,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
