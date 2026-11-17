// ignore_for_file: non_constant_identifier_names

class Schedule {
  final int? schedule_id;
  final int subject_id;
  final String day_of_week;
  final String start_time;
  final String end_time;
  final String room;
  final int slot_capacity;

  Schedule({
    this.schedule_id,
    required this.subject_id,
    required this.day_of_week,
    required this.start_time,
    required this.end_time,
    required this.room,
    required this.slot_capacity,
  });

  static String _timeToText(dynamic value) {
    final match = RegExp(r'(\d{2}):(\d{2})').firstMatch(value.toString());
    return match == null ? value.toString() : '${match[1]}:${match[2]}';
  }

  factory Schedule.fromMap(Map<String, dynamic> map) {
    return Schedule(
      schedule_id: map['schedule_id'] as int?,
      subject_id: map['subject_id'] as int,
      day_of_week: map['day_of_week'] as String,
      start_time: _timeToText(map['start_time']),
      end_time: _timeToText(map['end_time']),
      room: map['room'] as String,
      slot_capacity: map['slot_capacity'] as int,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'subject_id': subject_id,
      'day_of_week': day_of_week,
      'start_time': start_time,
      'end_time': end_time,
      'room': room,
      'slot_capacity': slot_capacity,
    };
  }
}
