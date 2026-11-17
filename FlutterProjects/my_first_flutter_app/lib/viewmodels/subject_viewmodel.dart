import 'package:flutter/foundation.dart';
import 'package:postgres/postgres.dart';
import '../models/subject.dart';
import '../repositories/subject_repository.dart';

class SubjectViewModel extends ChangeNotifier {
  final SubjectRepository _repository = SubjectRepository();

  List<Subject> subjects = [];
  bool isLoading = false;
  String? errorMessage;

  Future<void> loadSubjects({bool showLoading = true}) async {
    if (showLoading) {
      isLoading = true;
    }
    errorMessage = null;
    notifyListeners();

    try {
      subjects = await _repository.getAllSubjects();
    } catch (e) {
      errorMessage = _friendlyError(e);
    }

    isLoading = false;
    notifyListeners();
  }

  Future<bool> addSubject(Subject subject) async {
    try {
      await _repository.addSubject(subject);
      await loadSubjects(showLoading: false);
      return true;
    } catch (e) {
      errorMessage = _friendlyError(e);
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateSubject(Subject subject) async {
    try {
      await _repository.updateSubject(subject);
      await loadSubjects(showLoading: false);
      return true;
    } catch (e) {
      errorMessage = _friendlyError(e);
      notifyListeners();
      return false;
    }
  }

  Future<bool> deleteSubject(Subject subject) async {
    try {
      await _repository.deleteSubject(subject.subject_id!);
      await loadSubjects(showLoading: false);
      return true;
    } catch (e) {
      errorMessage = _friendlyError(e);
      notifyListeners();
      return false;
    }
  }

  String _friendlyError(Object e) {
    if (e is ServerException) {
      if (e.code == '23505') return 'Subject code already exists';
      if (e.code == '23503') {
        return 'Cannot delete: this subject still has enrollments';
      }
      if (e.code == '23514') return 'Units must be from 1 to 6';
      if (e.code == '22001') return 'A value is too long';
    }
    return 'Something went wrong: $e';
  }
}

final SubjectViewModel subjectViewModel = SubjectViewModel();
