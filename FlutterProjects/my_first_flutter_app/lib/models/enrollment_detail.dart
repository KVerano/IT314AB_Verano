// ignore_for_file: non_constant_identifier_names

import 'schedule.dart';

class EnrollmentDetail {
  final int enrollment_id;
  final int student_id;
  final int subject_id;
  final int schedule_id;
  final String status;
  final String subject_code;
  final String subject_name;
  final List<Schedule> schedules;

  EnrollmentDetail({
    required this.enrollment_id,
    required this.student_id,
    required this.subject_id,
    required this.schedule_id,
    required this.status,
    required this.subject_code,
    required this.subject_name,
    required this.schedules,
  });

  factory EnrollmentDetail.fromMap(
    Map<String, dynamic> map,
    List<Schedule> schedules,
  ) {
    return EnrollmentDetail(
      enrollment_id: map['enrollment_id'] as int,
      student_id: map['student_id'] as int,
      subject_id: map['subject_id'] as int,
      schedule_id: map['schedule_id'] as int,
      status: map['status'] as String,
      subject_code: map['subject_code'] as String,
      subject_name: map['subject_name'] as String,
      schedules: schedules,
    );
  }
}
