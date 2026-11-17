import 'package:postgres/postgres.dart';
import '../core/db_connection.dart';
import '../models/student.dart';

class StudentRepository {
  Future<List<Student>> getAllStudents() async {
    final connection = await DbConnection.getConnection();
    final result = await connection.execute(
      'SELECT student_id, student_number, first_name, last_name, email, '
      'course, year_level, contact_number, created_at '
      'FROM students ORDER BY last_name, first_name',
    );
    return result.map((row) => Student.fromMap(row.toColumnMap())).toList();
  }

  Future<void> addStudent(Student student) async {
    final connection = await DbConnection.getConnection();
    await connection.execute(
      Sql.named(
        'INSERT INTO students (student_number, first_name, last_name, email, '
        'course, year_level, contact_number) '
        'VALUES (@student_number, @first_name, @last_name, @email, '
        '@course, @year_level, @contact_number)',
      ),
      parameters: student.toMap(),
    );
  }

  Future<void> updateStudent(Student student) async {
    final connection = await DbConnection.getConnection();
    await connection.execute(
      Sql.named(
        'UPDATE students SET student_number = @student_number, '
        'first_name = @first_name, last_name = @last_name, email = @email, '
        'course = @course, year_level = @year_level, '
        'contact_number = @contact_number '
        'WHERE student_id = @student_id',
      ),
      parameters: {...student.toMap(), 'student_id': student.student_id},
    );
  }

  Future<void> deleteStudent(int studentId) async {
    final connection = await DbConnection.getConnection();
    await connection.execute(
      Sql.named('DELETE FROM students WHERE student_id = @student_id'),
      parameters: {'student_id': studentId},
    );
  }
}
