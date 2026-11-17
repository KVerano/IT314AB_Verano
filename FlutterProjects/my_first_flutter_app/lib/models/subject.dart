// ignore_for_file: non_constant_identifier_names

class Subject {
  final int? subject_id;
  final String subject_code;
  final String subject_name;
  final int units;
  final String? description;

  Subject({
    this.subject_id,
    required this.subject_code,
    required this.subject_name,
    required this.units,
    this.description,
  });

  factory Subject.fromMap(Map<String, dynamic> map) {
    return Subject(
      subject_id: map['subject_id'] as int?,
      subject_code: map['subject_code'] as String,
      subject_name: map['subject_name'] as String,
      units: map['units'] as int,
      description: map['description'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'subject_code': subject_code,
      'subject_name': subject_name,
      'units': units,
      'description': description,
    };
  }
}
