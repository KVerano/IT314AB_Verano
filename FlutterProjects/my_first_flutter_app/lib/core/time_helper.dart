import 'package:flutter/material.dart';

String timeOfDayToText(TimeOfDay time) {
  String hour = time.hour.toString().padLeft(2, '0');
  String minute = time.minute.toString().padLeft(2, '0');
  return '$hour:$minute';
}

TimeOfDay textToTimeOfDay(String text) {
  List<String> parts = text.split(':');
  return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
}

String formatTime12Hour(String text) {
  TimeOfDay time = textToTimeOfDay(text);
  int hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
  String minute = time.minute.toString().padLeft(2, '0');
  String period = time.period == DayPeriod.am ? 'AM' : 'PM';
  return '$hour:$minute $period';
}
