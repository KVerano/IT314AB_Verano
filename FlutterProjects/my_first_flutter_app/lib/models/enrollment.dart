// ignore_for_file: non_constant_identifier_names

class Enrollment {
  final int? enrollment_id;
  final int student_id;
  final int subject_id;
  final int schedule_id;
  final DateTime? enrolled_at;
  final String status;

  Enrollment({
    this.enrollment_id,
    required this.student_id,
    required this.subject_id,
    required this.schedule_id,
    this.enrolled_at,
    this.status = 'Enrolled',
  });

  factory Enrollment.fromMap(Map<String, dynamic> map) {
    return Enrollment(
      enrollment_id: map['enrollment_id'] as int?,
      student_id: map['student_id'] as int,
      subject_id: map['subject_id'] as int,
      schedule_id: map['schedule_id'] as int,
      enrolled_at: map['enrolled_at'] as DateTime?,
      status: map['status'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'student_id': student_id,
      'subject_id': subject_id,
      'schedule_id': schedule_id,
      'status': status,
    };
  }
}
