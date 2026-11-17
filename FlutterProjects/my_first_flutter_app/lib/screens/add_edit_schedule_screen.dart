import 'package:flutter/material.dart';
import '../core/time_helper.dart';
import '../models/schedule.dart';
import '../models/subject.dart';
import '../viewmodels/schedule_viewmodel.dart';

class AddEditScheduleScreen extends StatefulWidget {
  final Subject subject;
  final Schedule? schedule;

  const AddEditScheduleScreen({
    super.key,
    required this.subject,
    this.schedule,
  });

  @override
  State<AddEditScheduleScreen> createState() => _AddEditScheduleScreenState();
}

class _AddEditScheduleScreenState extends State<AddEditScheduleScreen> {
  final _formKey = GlobalKey<FormState>();

  final startTimeController = TextEditingController();
  final endTimeController = TextEditingController();
  final roomController = TextEditingController();
  final slotCapacityController = TextEditingController();

  String startTimeValue = '';
  String endTimeValue = '';

  String? selectedDay;

  final List<String> days = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday',
  ];

  @override
  void initState() {
    super.initState();

    final schedule = widget.schedule;

    if (schedule != null) {
      selectedDay = schedule.day_of_week;
      startTimeValue = schedule.start_time;
      endTimeValue = schedule.end_time;
      startTimeController.text = formatTime12Hour(schedule.start_time);
      endTimeController.text = formatTime12Hour(schedule.end_time);
      roomController.text = schedule.room;
      slotCapacityController.text = schedule.slot_capacity.toString();
    }
  }

  @override
  void dispose() {
    startTimeController.dispose();
    endTimeController.dispose();
    roomController.dispose();
    slotCapacityController.dispose();
    super.dispose();
  }

  Future<void> pickTime(bool isStart) async {
    String current = isStart ? startTimeValue : endTimeValue;

    TimeOfDay startingTime = current.isEmpty
        ? const TimeOfDay(hour: 8, minute: 0)
        : textToTimeOfDay(current);

    final picked = await showTimePicker(
      context: context,
      initialTime: startingTime,
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
          child: child!,
        );
      },
    );

    if (picked != null) {
      String value = timeOfDayToText(picked);

      if (isStart) {
        startTimeValue = value;
        startTimeController.text = formatTime12Hour(value);
      } else {
        endTimeValue = value;
        endTimeController.text = formatTime12Hour(value);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.schedule == null ? "Add Schedule" : "Edit Schedule"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Text(
                "${widget.subject.subject_code} - ${widget.subject.subject_name}",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              DropdownButtonFormField<String>(
                value: selectedDay,
                decoration: const InputDecoration(
                  labelText: "Day",
                  border: OutlineInputBorder(),
                ),
                items: days.map((day) {
                  return DropdownMenuItem(value: day, child: Text(day));
                }).toList(),
                onChanged: (value) {
                  selectedDay = value;
                },
                validator: (value) {
                  if (value == null) {
                    return "Please select a Day";
                  }
                  return null;
                },
              ),
              SizedBox(height: 15),
              TextFormField(
                controller: startTimeController,
                readOnly: true,
                onTap: () {
                  pickTime(true);
                },
                decoration: const InputDecoration(
                  labelText: "Start Time",
                  border: OutlineInputBorder(),
                  suffixIcon: Icon(Icons.access_time),
                ),
                validator: (value) {
                  if (startTimeValue.isEmpty) {
                    return "Please select Start Time";
                  }
                  return null;
                },
              ),
              SizedBox(height: 15),
              TextFormField(
                controller: endTimeController,
                readOnly: true,
                onTap: () {
                  pickTime(false);
                },
                decoration: const InputDecoration(
                  labelText: "End Time",
                  border: OutlineInputBorder(),
                  suffixIcon: Icon(Icons.access_time),
                ),
                validator: (value) {
                  if (endTimeValue.isEmpty) {
                    return "Please select End Time";
                  }
                  if (startTimeValue.isNotEmpty &&
                      endTimeValue.compareTo(startTimeValue) <= 0) {
                    return "End Time must be later than Start Time";
                  }
                  return null;
                },
              ),
              SizedBox(height: 15),
              TextFormField(
                controller: roomController,
                decoration: const InputDecoration(
                  labelText: "Room",
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Please enter Room";
                  }
                  return null;
                },
              ),
              SizedBox(height: 15),
              TextFormField(
                controller: slotCapacityController,
                decoration: const InputDecoration(
                  labelText: "Slot Capacity",
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Please enter Slot Capacity";
                  }
                  int? capacity = int.tryParse(value.trim());
                  if (capacity == null || capacity <= 0) {
                    return "Slot Capacity must be above 0";
                  }
                  if (capacity > 1000) {
                    return "Slot Capacity is too big (maximum 1000)";
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        Schedule newSchedule = Schedule(
                          schedule_id: widget.schedule?.schedule_id,
                          subject_id: widget.subject.subject_id!,
                          day_of_week: selectedDay!,
                          start_time: startTimeValue,
                          end_time: endTimeValue,
                          room: roomController.text.trim(),
                          slot_capacity: int.parse(
                            slotCapacityController.text.trim(),
                          ),
                        );

                        bool saved = widget.schedule == null
                            ? await scheduleViewModel.addSchedule(newSchedule)
                            : await scheduleViewModel.updateSchedule(
                                newSchedule,
                              );

                        if (!mounted) return;

                        if (!saved) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                scheduleViewModel.errorMessage ??
                                    "Could not save schedule",
                              ),
                            ),
                          );
                          return;
                        }

                        Navigator.pop(context);
                      }
                    },
                    child: Text(
                      widget.schedule == null ? "Add Schedule" : "Save",
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
