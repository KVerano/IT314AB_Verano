// ignore_for_file: non_constant_identifier_names

class Student {
  final int? student_id;
  final String student_number;
  final String first_name;
  final String last_name;
  final String email;
  final String course;
  final int year_level;
  final String contact_number;
  final DateTime? created_at;

  Student({
    this.student_id,
    required this.student_number,
    required this.first_name,
    required this.last_name,
    required this.email,
    required this.course,
    required this.year_level,
    required this.contact_number,
    this.created_at,
  });

  factory Student.fromMap(Map<String, dynamic> map) {
    return Student(
      student_id: map['student_id'] as int?,
      student_number: map['student_number'] as String,
      first_name: map['first_name'] as String,
      last_name: map['last_name'] as String,
      email: map['email'] as String,
      course: map['course'] as String,
      year_level: map['year_level'] as int,
      contact_number: map['contact_number'] as String,
      created_at: map['created_at'] as DateTime?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'student_number': student_number,
      'first_name': first_name,
      'last_name': last_name,
      'email': email,
      'course': course,
      'year_level': year_level,
      'contact_number': contact_number,
    };
  }
}
