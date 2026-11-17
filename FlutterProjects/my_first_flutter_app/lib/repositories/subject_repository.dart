import 'package:postgres/postgres.dart';
import '../core/db_connection.dart';
import '../models/subject.dart';

class SubjectRepository {
  Future<List<Subject>> getAllSubjects() async {
    final connection = await DbConnection.getConnection();
    final result = await connection.execute(
      'SELECT subject_id, subject_code, subject_name, units, description '
      'FROM subjects ORDER BY subject_code',
    );
    return result.map((row) => Subject.fromMap(row.toColumnMap())).toList();
  }

  Future<void> addSubject(Subject subject) async {
    final connection = await DbConnection.getConnection();
    await connection.execute(
      Sql.named(
        'INSERT INTO subjects (subject_code, subject_name, units, description) '
        'VALUES (@subject_code, @subject_name, @units, @description)',
      ),
      parameters: subject.toMap(),
    );
  }

  Future<void> updateSubject(Subject subject) async {
    final connection = await DbConnection.getConnection();
    await connection.execute(
      Sql.named(
        'UPDATE subjects SET subject_code = @subject_code, '
        'subject_name = @subject_name, units = @units, '
        'description = @description WHERE subject_id = @subject_id',
      ),
      parameters: {...subject.toMap(), 'subject_id': subject.subject_id},
    );
  }

  Future<void> deleteSubject(int subjectId) async {
    final connection = await DbConnection.getConnection();
    await connection.execute(
      Sql.named('DELETE FROM subjects WHERE subject_id = @subject_id'),
      parameters: {'subject_id': subjectId},
    );
  }
}
