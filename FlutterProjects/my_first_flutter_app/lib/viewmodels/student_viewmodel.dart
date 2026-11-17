import 'package:flutter/foundation.dart';
import 'package:postgres/postgres.dart';
import '../core/db_connection.dart';
import '../models/student.dart';
import '../repositories/student_repository.dart';

class StudentViewModel extends ChangeNotifier {
  final StudentRepository _repository = StudentRepository();

  List<Student> students = [];
  bool isLoading = false;
  String? errorMessage;

  Future<String> checkConnection() {
    return DbConnection.testConnection();
  }

  Future<void> loadStudents({bool showLoading = true}) async {
    if (showLoading) {
      isLoading = true;
    }
    errorMessage = null;
    notifyListeners();

    try {
      students = await _repository.getAllStudents();
    } catch (e) {
      errorMessage = _friendlyError(e);
    }

    isLoading = false;
    notifyListeners();
  }

  Future<bool> addStudent(Student student) async {
    try {
      await _repository.addStudent(student);
      await loadStudents(showLoading: false);
      return true;
    } catch (e) {
      errorMessage = _friendlyError(e);
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateStudent(Student student) async {
    try {
      await _repository.updateStudent(student);
      await loadStudents(showLoading: false);
      return true;
    } catch (e) {
      errorMessage = _friendlyError(e);
      notifyListeners();
      return false;
    }
  }

  Future<bool> deleteStudent(Student student) async {
    try {
      await _repository.deleteStudent(student.student_id!);
      await loadStudents(showLoading: false);
      return true;
    } catch (e) {
      errorMessage = _friendlyError(e);
      notifyListeners();
      return false;
    }
  }

  String _friendlyError(Object e) {
    if (e is ServerException) {
      if (e.code == '23505') return 'Student ID or email already exists';
      if (e.code == '23503') {
        return 'Cannot delete: this student still has enrollments';
      }
      if (e.code == '23514') return 'A value is not allowed. Check year level';
      if (e.code == '22001') return 'A value is too long';
    }
    return 'Something went wrong: $e';
  }
}

final StudentViewModel studentViewModel = StudentViewModel();
