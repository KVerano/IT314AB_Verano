// ignore_for_file: non_constant_identifier_names

class GradeDetail {
  final int grade_id;
  final int enrollment_id;
  final int student_id;
  final double grade_value;
  final String? remarks;
  final DateTime? date_recorded;
  final String subject_code;
  final String subject_name;

  GradeDetail({
    required this.grade_id,
    required this.enrollment_id,
    required this.student_id,
    required this.grade_value,
    this.remarks,
    this.date_recorded,
    required this.subject_code,
    required this.subject_name,
  });

  factory GradeDetail.fromMap(Map<String, dynamic> map) {
    return GradeDetail(
      grade_id: map['grade_id'] as int,
      enrollment_id: map['enrollment_id'] as int,
      student_id: map['student_id'] as int,
      grade_value: double.parse(map['grade_value'].toString()),
      remarks: map['remarks'] as String?,
      date_recorded: map['date_recorded'] as DateTime?,
      subject_code: map['subject_code'] as String,
      subject_name: map['subject_name'] as String,
    );
  }
}
