// ignore_for_file: non_constant_identifier_names

class Grade {
  final int? grade_id;
  final int enrollment_id;
  final double grade_value;
  final String? remarks;
  final DateTime? date_recorded;

  Grade({
    this.grade_id,
    required this.enrollment_id,
    required this.grade_value,
    this.remarks,
    this.date_recorded,
  });

  factory Grade.fromMap(Map<String, dynamic> map) {
    return Grade(
      grade_id: map['grade_id'] as int?,
      enrollment_id: map['enrollment_id'] as int,
      grade_value: double.parse(map['grade_value'].toString()),
      remarks: map['remarks'] as String?,
      date_recorded: map['date_recorded'] as DateTime?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'enrollment_id': enrollment_id,
      'grade_value': grade_value,
      'remarks': remarks,
    };
  }
}
