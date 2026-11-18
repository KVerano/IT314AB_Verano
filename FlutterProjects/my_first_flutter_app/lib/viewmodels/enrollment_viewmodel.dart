import 'package:flutter/foundation.dart';
import 'package:postgres/postgres.dart';
import '../models/enrollment.dart';
import '../models/enrollment_detail.dart';
import '../models/schedule.dart';
import '../models/subject.dart';
import '../repositories/enrollment_repository.dart';
import '../repositories/schedule_repository.dart';

class EnrollmentViewModel extends ChangeNotifier {
  final EnrollmentRepository _repository = EnrollmentRepository();
  final ScheduleRepository _scheduleRepository = ScheduleRepository();

  List<EnrollmentDetail> enrollments = [];
  Map<int, int> remainingSlots = {};
  Set<int> enrolledSubjectIds = {};
  bool isLoading = false;
  String? errorMessage;

  Future<void> loadEnrollments(int studentId, {bool showLoading = true}) async {
    if (showLoading) {
      isLoading = true;
    }
    errorMessage = null;
    notifyListeners();

    try {
      enrollments = await _repository.getEnrollmentsByStudent(studentId);
    } catch (e) {
      errorMessage = _friendlyError(e);
    }

    isLoading = false;
    notifyListeners();
  }

  Future<void> loadRemainingSlots() async {
    try {
      remainingSlots = await _repository.getRemainingSlotsForAllSubjects();
    } catch (e) {
      remainingSlots = {};
      errorMessage = _friendlyError(e);
    }
    notifyListeners();
  }

  Future<void> loadEnrolledSubjectIds(int studentId) async {
    try {
      enrolledSubjectIds = await _repository.getEnrolledSubjectIds(studentId);
    } catch (e) {
      enrolledSubjectIds = {};
      errorMessage = _friendlyError(e);
    }
    notifyListeners();
  }

  Future<bool> enrollStudent(int studentId, List<Subject> subjects) async {
    try {
      if (subjects.isEmpty) {
        return _stop('Please select at least one subject');
      }

      Map<int, List<Schedule>> schedulesBySubject = {};

      for (Subject subject in subjects) {
        String? problem = await _checkSubject(studentId, subject);

        if (problem != null) {
          return _stop('${subject.subject_code} $problem');
        }

        schedulesBySubject[subject.subject_id!] = await _scheduleRepository
            .getSchedulesBySubject(subject.subject_id!);
      }

      String? clash = _findClashBetween(subjects, schedulesBySubject);

      if (clash != null) {
        return _stop(clash);
      }

      for (Subject subject in subjects) {
        Schedule mainSchedule = schedulesBySubject[subject.subject_id!]!.first;

        await _repository.addEnrollment(
          Enrollment(
            student_id: studentId,
            subject_id: subject.subject_id!,
            schedule_id: mainSchedule.schedule_id!,
          ),
        );
      }

      await loadEnrollments(studentId, showLoading: false);
      await loadRemainingSlots();
      return true;
    } catch (e) {
      return _stop(_friendlyError(e));
    }
  }

  Future<String?> _checkSubject(int studentId, Subject subject) async {
    int subjectId = subject.subject_id!;

    bool alreadyEnrolled = await _repository.isAlreadyEnrolled(
      studentId,
      subjectId,
    );

    if (alreadyEnrolled) {
      return 'is already enrolled in this subject';
    }

    int? remaining = await _repository.getRemainingSlots(subjectId);

    if (remaining == null) {
      return 'has no schedules yet';
    }

    if (remaining <= 0) {
      return 'is full. No slots left';
    }

    String? conflict = await _repository.findConflictingSubject(
      studentId,
      subjectId,
    );

    if (conflict != null) {
      return 'has a schedule conflict with $conflict';
    }

    return null;
  }

  String? _findClashBetween(
    List<Subject> subjects,
    Map<int, List<Schedule>> schedulesBySubject,
  ) {
    for (int i = 0; i < subjects.length; i++) {
      for (int j = i + 1; j < subjects.length; j++) {
        for (Schedule first in schedulesBySubject[subjects[i].subject_id!]!) {
          for (Schedule second
              in schedulesBySubject[subjects[j].subject_id!]!) {
            bool sameDay = first.day_of_week == second.day_of_week;
            bool overlap =
                first.start_time.compareTo(second.end_time) < 0 &&
                first.end_time.compareTo(second.start_time) > 0;

            if (sameDay && overlap) {
              return '${subjects[i].subject_code} and ${subjects[j].subject_code} have schedules that overlap';
            }
          }
        }
      }
    }

    return null;
  }

  Future<bool> changeSchedule(
    EnrollmentDetail enrollment,
    int newScheduleId,
  ) async {
    try {
      await _repository.changeSchedule(enrollment.enrollment_id, newScheduleId);
      await loadEnrollments(enrollment.student_id, showLoading: false);
      return true;
    } catch (e) {
      return _stop(_friendlyError(e));
    }
  }

  Future<bool> dropEnrollment(EnrollmentDetail enrollment) async {
    try {
      await _repository.dropEnrollment(enrollment.enrollment_id);
      await loadEnrollments(enrollment.student_id, showLoading: false);
      await loadRemainingSlots();
      return true;
    } catch (e) {
      return _stop(_friendlyError(e));
    }
  }

  bool _stop(String message) {
    errorMessage = message;
    notifyListeners();
    return false;
  }

  String _friendlyError(Object e) {
    if (e is ServerException) {
      if (e.code == '23505') {
        return 'This student is already enrolled in this subject';
      }
      if (e.code == '23503') {
        return 'The student, subject or schedule no longer exists';
      }
      if (e.code == '23514') return 'A value is not allowed';
    }
    return 'Something went wrong: $e';
  }
}

final EnrollmentViewModel enrollmentViewModel = EnrollmentViewModel();
