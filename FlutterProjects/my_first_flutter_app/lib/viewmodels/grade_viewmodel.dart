import 'package:flutter/foundation.dart';
import 'package:postgres/postgres.dart';
import '../models/grade.dart';
import '../models/grade_detail.dart';
import '../repositories/grade_repository.dart';

class GradeViewModel extends ChangeNotifier {
  final GradeRepository _repository = GradeRepository();

  List<GradeDetail> grades = [];
  bool isLoading = false;
  String? errorMessage;

  Future<void> loadGrades(int studentId, {bool showLoading = true}) async {
    if (showLoading) {
      isLoading = true;
    }
    errorMessage = null;
    notifyListeners();

    try {
      grades = await _repository.getGradesByStudent(studentId);
    } catch (e) {
      errorMessage = _friendlyError(e);
    }

    isLoading = false;
    notifyListeners();
  }

  Future<bool> addGrade(Grade grade, int studentId) async {
    try {
      await _repository.addGrade(grade);
      await loadGrades(studentId, showLoading: false);
      return true;
    } catch (e) {
      errorMessage = _friendlyError(e);
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateGrade(Grade grade, int studentId) async {
    try {
      await _repository.updateGrade(grade);
      await loadGrades(studentId, showLoading: false);
      return true;
    } catch (e) {
      errorMessage = _friendlyError(e);
      notifyListeners();
      return false;
    }
  }

  Future<bool> deleteGrade(GradeDetail grade) async {
    try {
      await _repository.deleteGrade(grade.grade_id);
      await loadGrades(grade.student_id, showLoading: false);
      return true;
    } catch (e) {
      errorMessage = _friendlyError(e);
      notifyListeners();
      return false;
    }
  }

  String _friendlyError(Object e) {
    if (e is ServerException) {
      if (e.code == '23505') return 'This enrollment already has a grade';
      if (e.code == '23503') return 'This enrollment no longer exists';
      if (e.code == '23514') return 'Grade must be from 0 to 100';
      if (e.code == '22003') return 'The grade number is too big';
      if (e.code == '22001') return 'A value is too long';
    }
    return 'Something went wrong: $e';
  }
}

final GradeViewModel gradeViewModel = GradeViewModel();
