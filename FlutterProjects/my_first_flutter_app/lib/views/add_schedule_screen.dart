import 'package:flutter/material.dart';
import '../core/time_helper.dart';
import '../models/schedule.dart';
import '../viewmodels/schedule_viewmodel.dart';
import '../viewmodels/subject_viewmodel.dart';
import 'side_menu.dart';

class AddScheduleScreen extends StatefulWidget {
  const AddScheduleScreen({super.key});

  @override
  State<AddScheduleScreen> createState() => _AddScheduleScreenState();
}

class _AddScheduleScreenState extends State<AddScheduleScreen> {
  final _formKey = GlobalKey<FormState>();

  final startTimeController = TextEditingController();
  final endTimeController = TextEditingController();
  final roomController = TextEditingController();
  final slotCapacityController = TextEditingController();

  String startTimeValue = '';
  String endTimeValue = '';

  int? selectedSubjectId;
  String? selectedDay;
  int formVersion = 0;

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
    Future.microtask(loadSubjects);
  }

  @override
  void dispose() {
    startTimeController.dispose();
    endTimeController.dispose();
    roomController.dispose();
    slotCapacityController.dispose();
    super.dispose();
  }

  Future<void> loadSubjects() async {
    await subjectViewModel.loadSubjects(showLoading: false);

    if (!mounted) return;

    if (subjectViewModel.errorMessage != null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(subjectViewModel.errorMessage!)));
    }

    setState(() {});
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
        automaticallyImplyLeading: false,
        title: const Text("DBTC Enrollment Management System"),
      ),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SideMenu(selected: 'schedules'),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 43,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Schedules",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    DropdownButtonFormField<int>(
                      key: ValueKey("subject-$formVersion"),
                      value: selectedSubjectId,
                      isExpanded: true,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      decoration: const InputDecoration(
                        labelText: "Subject",
                        border: OutlineInputBorder(),
                      ),
                      items: subjectViewModel.subjects.map((subject) {
                        return DropdownMenuItem<int>(
                          value: subject.subject_id!,
                          child: Text(
                            "${subject.subject_code} - ${subject.subject_name}",
                            overflow: TextOverflow.ellipsis,
                          ),
                        );
                      }).toList(),
                      onChanged: (value) {
                        selectedSubjectId = value;
                      },
                      validator: (value) {
                        if (value == null) {
                          return "Please select a Subject";
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 15),
                    DropdownButtonFormField<String>(
                      key: ValueKey("day-$formVersion"),
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
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(160, 40),
                          ),
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              Schedule newSchedule = Schedule(
                                subject_id: selectedSubjectId!,
                                day_of_week: selectedDay!,
                                start_time: startTimeValue,
                                end_time: endTimeValue,
                                room: roomController.text.trim(),
                                slot_capacity: int.parse(
                                  slotCapacityController.text.trim(),
                                ),
                              );

                              bool saved = await scheduleViewModel.addSchedule(
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

                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Schedule added successfully"),
                                ),
                              );

                              startTimeController.clear();
                              endTimeController.clear();
                              roomController.clear();
                              slotCapacityController.clear();

                              setState(() {
                                selectedSubjectId = null;
                                selectedDay = null;
                                startTimeValue = '';
                                endTimeValue = '';
                                formVersion++;
                              });
                            }
                          },
                          child: const Text("Add Schedule"),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
