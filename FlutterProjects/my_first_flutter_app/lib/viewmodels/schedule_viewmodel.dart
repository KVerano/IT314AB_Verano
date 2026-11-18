import 'package:flutter/foundation.dart';
import 'package:postgres/postgres.dart';
import '../models/schedule.dart';
import '../repositories/schedule_repository.dart';
import '../repositories/enrollment_repository.dart';

class ScheduleViewModel extends ChangeNotifier {
  final ScheduleRepository _repository = ScheduleRepository();
  final EnrollmentRepository _enrollmentRepository = EnrollmentRepository();

  List<Schedule> schedules = [];
  bool isLoading = false;
  String? errorMessage;

  Future<void> loadSchedules(int subjectId, {bool showLoading = true}) async {
    if (showLoading) {
      isLoading = true;
    }
    errorMessage = null;
    notifyListeners();

    try {
      schedules = await _repository.getSchedulesBySubject(subjectId);
    } catch (e) {
      errorMessage = _friendlyError(e);
    }

    isLoading = false;
    notifyListeners();
  }

  Future<bool> addSchedule(Schedule schedule) async {
    try {
      await _repository.addSchedule(schedule);
      await loadSchedules(schedule.subject_id, showLoading: false);
      return true;
    } catch (e) {
      errorMessage = _friendlyError(e);
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateSchedule(Schedule schedule) async {
    try {
      int enrolled = await _enrollmentRepository.countEnrolledInSubject(
        schedule.subject_id,
      );

      if (schedule.slot_capacity < enrolled) {
        errorMessage =
            'Slot capacity cannot be lower than the $enrolled students already enrolled';
        notifyListeners();
        return false;
      }

      await _repository.updateSchedule(schedule);
      await loadSchedules(schedule.subject_id, showLoading: false);
      return true;
    } catch (e) {
      errorMessage = _friendlyError(e);
      notifyListeners();
      return false;
    }
  }

  Future<bool> deleteSchedule(Schedule schedule) async {
    try {
      await _repository.deleteSchedule(schedule.schedule_id!);
      await loadSchedules(schedule.subject_id, showLoading: false);
      return true;
    } catch (e) {
      errorMessage = _friendlyError(e);
      notifyListeners();
      return false;
    }
  }

  String _friendlyError(Object e) {
    if (e is ServerException) {
      if (e.code == '23514') {
        return 'Make sure the day and available slots are correct, and the end time is later than the start time';
      }
      if (e.code == '23503') {
        return 'Cannot delete: students are enrolled in this schedule';
      }
      if (e.code == '22003') return 'A number is too big';
      if (e.code == '22001') return 'A value is too long';
    }
    return 'Something went wrong: $e';
  }
}

final ScheduleViewModel scheduleViewModel = ScheduleViewModel();
