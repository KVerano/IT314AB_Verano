import 'package:postgres/postgres.dart';
import '../core/db_connection.dart';
import '../models/grade.dart';
import '../models/grade_detail.dart';

class GradeRepository {
  Future<List<GradeDetail>> getGradesByStudent(int studentId) async {
    final connection = await DbConnection.getConnection();
    final result = await connection.execute(
      Sql.named(
        'SELECT g.grade_id, g.enrollment_id, e.student_id, '
        'CAST(g.grade_value AS double precision) AS grade_value, '
        'g.remarks, g.date_recorded, s.subject_code, s.subject_name '
        'FROM grades g '
        'JOIN enrollments e ON e.enrollment_id = g.enrollment_id '
        'JOIN subjects s ON s.subject_id = e.subject_id '
        'WHERE e.student_id = @student_id '
        'ORDER BY s.subject_code',
      ),
      parameters: {'student_id': studentId},
    );
    return result.map((row) => GradeDetail.fromMap(row.toColumnMap())).toList();
  }

  Future<void> addGrade(Grade grade) async {
    final connection = await DbConnection.getConnection();
    await connection.execute(
      Sql.named(
        'INSERT INTO grades (enrollment_id, grade_value, remarks) '
        'VALUES (@enrollment_id, CAST(@grade_value AS double precision), '
        '@remarks)',
      ),
      parameters: grade.toMap(),
    );
  }

  Future<void> updateGrade(Grade grade) async {
    final connection = await DbConnection.getConnection();
    await connection.execute(
      Sql.named(
        'UPDATE grades SET '
        'grade_value = CAST(@grade_value AS double precision), '
        'remarks = @remarks WHERE grade_id = @grade_id',
      ),
      parameters: {
        'grade_value': grade.grade_value,
        'remarks': grade.remarks,
        'grade_id': grade.grade_id,
      },
    );
  }

  Future<void> deleteGrade(int gradeId) async {
    final connection = await DbConnection.getConnection();
    await connection.execute(
      Sql.named('DELETE FROM grades WHERE grade_id = @grade_id'),
      parameters: {'grade_id': gradeId},
    );
  }
}
