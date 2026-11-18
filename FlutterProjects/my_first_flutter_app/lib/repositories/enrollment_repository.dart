import 'package:postgres/postgres.dart';
import '../core/db_connection.dart';
import '../models/enrollment.dart';
import '../models/enrollment_detail.dart';
import '../models/schedule.dart';

class EnrollmentRepository {
  Future<List<EnrollmentDetail>> getEnrollmentsByStudent(int studentId) async {
    final connection = await DbConnection.getConnection();

    final enrollmentRows = await connection.execute(
      Sql.named(
        'SELECT e.enrollment_id, e.student_id, e.subject_id, e.schedule_id, '
        'e.status, s.subject_code, s.subject_name '
        'FROM enrollments e '
        'JOIN subjects s ON s.subject_id = e.subject_id '
        'WHERE e.student_id = @student_id '
        'ORDER BY s.subject_code',
      ),
      parameters: {'student_id': studentId},
    );

    final scheduleRows = await connection.execute(
      Sql.named(
        'SELECT schedule_id, subject_id, day_of_week, '
        'CAST(start_time AS text) AS start_time, '
        'CAST(end_time AS text) AS end_time, room, slot_capacity '
        'FROM schedules WHERE subject_id IN '
        '(SELECT subject_id FROM enrollments WHERE student_id = @student_id) '
        "ORDER BY array_position(ARRAY['Monday','Tuesday','Wednesday',"
        "'Thursday','Friday','Saturday','Sunday'], "
        'CAST(day_of_week AS text)), start_time',
      ),
      parameters: {'student_id': studentId},
    );

    final allSchedules = scheduleRows
        .map((row) => Schedule.fromMap(row.toColumnMap()))
        .toList();

    return enrollmentRows.map((row) {
      final map = row.toColumnMap();
      final subjectSchedules = allSchedules
          .where((schedule) => schedule.subject_id == map['subject_id'])
          .toList();
      return EnrollmentDetail.fromMap(map, subjectSchedules);
    }).toList();
  }

  Future<bool> isAlreadyEnrolled(int studentId, int subjectId) async {
    final connection = await DbConnection.getConnection();
    final result = await connection.execute(
      Sql.named(
        'SELECT COUNT(*) FROM enrollments '
        'WHERE student_id = @student_id AND subject_id = @subject_id '
        "AND status = 'Enrolled'",
      ),
      parameters: {'student_id': studentId, 'subject_id': subjectId},
    );
    return (result.first[0] as int) > 0;
  }

  Future<Set<int>> getEnrolledSubjectIds(int studentId) async {
    final connection = await DbConnection.getConnection();
    final result = await connection.execute(
      Sql.named(
        "SELECT subject_id FROM enrollments WHERE student_id = @student_id AND status = 'Enrolled'",
      ),
      parameters: {'student_id': studentId},
    );
    return result.map((row) => row[0] as int).toSet();
  }

  Future<int> countEnrolledInSubject(int subjectId) async {
    final connection = await DbConnection.getConnection();
    final result = await connection.execute(
      Sql.named(
        'SELECT COUNT(*) FROM enrollments '
        "WHERE subject_id = @subject_id AND status = 'Enrolled'",
      ),
      parameters: {'subject_id': subjectId},
    );
    return result.first[0] as int;
  }

  Future<int?> getRemainingSlots(int subjectId) async {
    final connection = await DbConnection.getConnection();
    final result = await connection.execute(
      Sql.named(
        'SELECT MIN(sc.slot_capacity) - (SELECT COUNT(*) FROM enrollments e '
        "WHERE e.subject_id = @subject_id AND e.status = 'Enrolled') "
        'FROM schedules sc WHERE sc.subject_id = @subject_id',
      ),
      parameters: {'subject_id': subjectId},
    );
    return result.first[0] as int?;
  }

  Future<Map<int, int>> getRemainingSlotsForAllSubjects() async {
    final connection = await DbConnection.getConnection();
    final result = await connection.execute(
      'SELECT sc.subject_id, MIN(sc.slot_capacity) - (SELECT COUNT(*) '
      'FROM enrollments e WHERE e.subject_id = sc.subject_id '
      "AND e.status = 'Enrolled') AS remaining "
      'FROM schedules sc GROUP BY sc.subject_id',
    );

    Map<int, int> slots = {};

    for (final row in result) {
      slots[row[0] as int] = row[1] as int;
    }

    return slots;
  }

  Future<String?> findConflictingSubject(int studentId, int subjectId) async {
    final connection = await DbConnection.getConnection();
    final result = await connection.execute(
      Sql.named(
        'SELECT s.subject_code FROM enrollments e '
        'JOIN subjects s ON s.subject_id = e.subject_id '
        'JOIN schedules existing ON existing.subject_id = e.subject_id '
        'JOIN schedules chosen ON chosen.subject_id = @subject_id '
        'WHERE e.student_id = @student_id '
        "AND e.status = 'Enrolled' "
        'AND e.subject_id <> @subject_id '
        'AND existing.day_of_week = chosen.day_of_week '
        'AND existing.start_time < chosen.end_time '
        'AND existing.end_time > chosen.start_time '
        'LIMIT 1',
      ),
      parameters: {'student_id': studentId, 'subject_id': subjectId},
    );
    if (result.isEmpty) return null;
    return result.first[0] as String;
  }

  Future<void> addEnrollment(Enrollment enrollment) async {
    final connection = await DbConnection.getConnection();
    await connection.execute(
      Sql.named(
        'INSERT INTO enrollments (student_id, subject_id, schedule_id, status) '
        'VALUES (@student_id, @subject_id, @schedule_id, @status) '
        'ON CONFLICT (student_id, subject_id) '
        'DO UPDATE SET schedule_id = EXCLUDED.schedule_id, '
        'status = EXCLUDED.status',
      ),
      parameters: enrollment.toMap(),
    );
  }

  Future<void> changeSchedule(int enrollmentId, int scheduleId) async {
    final connection = await DbConnection.getConnection();
    await connection.execute(
      Sql.named(
        'UPDATE enrollments SET schedule_id = @schedule_id '
        'WHERE enrollment_id = @enrollment_id',
      ),
      parameters: {'schedule_id': scheduleId, 'enrollment_id': enrollmentId},
    );
  }

  Future<void> dropEnrollment(int enrollmentId) async {
    final connection = await DbConnection.getConnection();
    await connection.execute(
      Sql.named(
        "UPDATE enrollments SET status = 'Dropped' "
        'WHERE enrollment_id = @enrollment_id',
      ),
      parameters: {'enrollment_id': enrollmentId},
    );
  }
}
