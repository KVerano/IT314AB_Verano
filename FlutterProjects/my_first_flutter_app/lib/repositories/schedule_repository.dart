import 'package:postgres/postgres.dart';
import '../core/db_connection.dart';
import '../models/schedule.dart';

class ScheduleRepository {
  Future<List<Schedule>> getSchedulesBySubject(int subjectId) async {
    final connection = await DbConnection.getConnection();
    final result = await connection.execute(
      Sql.named(
        'SELECT schedule_id, subject_id, day_of_week, '
        'CAST(start_time AS text) AS start_time, '
        'CAST(end_time AS text) AS end_time, room, slot_capacity '
        'FROM schedules WHERE subject_id = @subject_id '
        "ORDER BY array_position(ARRAY['Monday','Tuesday','Wednesday',"
        "'Thursday','Friday','Saturday','Sunday'], "
        'CAST(day_of_week AS text)), start_time',
      ),
      parameters: {'subject_id': subjectId},
    );
    return result.map((row) => Schedule.fromMap(row.toColumnMap())).toList();
  }

  // note to me: times are sent as text then sa Neon turns time
  Future<void> addSchedule(Schedule schedule) async {
    final connection = await DbConnection.getConnection();
    await connection.execute(
      Sql.named(
        'INSERT INTO schedules (subject_id, day_of_week, start_time, '
        'end_time, room, slot_capacity) '
        'VALUES (@subject_id, @day_of_week, '
        'CAST(CAST(@start_time AS text) AS time), '
        'CAST(CAST(@end_time AS text) AS time), @room, @slot_capacity)',
      ),
      parameters: schedule.toMap(),
    );
  }

  Future<void> updateSchedule(Schedule schedule) async {
    final connection = await DbConnection.getConnection();
    await connection.execute(
      Sql.named(
        'UPDATE schedules SET subject_id = @subject_id, '
        'day_of_week = @day_of_week, '
        'start_time = CAST(CAST(@start_time AS text) AS time), '
        'end_time = CAST(CAST(@end_time AS text) AS time), '
        'room = @room, slot_capacity = @slot_capacity '
        'WHERE schedule_id = @schedule_id',
      ),
      parameters: {...schedule.toMap(), 'schedule_id': schedule.schedule_id},
    );
  }

  Future<void> deleteSchedule(int scheduleId) async {
    final connection = await DbConnection.getConnection();
    await connection.execute(
      Sql.named('DELETE FROM schedules WHERE schedule_id = @schedule_id'),
      parameters: {'schedule_id': scheduleId},
    );
  }
}
