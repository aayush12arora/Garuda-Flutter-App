import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sih/Services/markattendance.dart';
import 'package:table_calendar/table_calendar.dart';

class WorkingHours extends StatefulWidget {
  const WorkingHours({super.key});

  @override
  State<WorkingHours> createState() => _WorkingHoursState();
}

class _WorkingHoursState extends State<WorkingHours> {
  DateTime _selectedDay = DateTime.now();
  bool _isLoading = false; // Indicator for loading state

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calendar and Working Hours'),
      ),
      body: Column(
        children: [
          TableCalendar(
            focusedDay: _selectedDay,
            firstDay: DateTime.utc(2020, 1, 1),
            lastDay: DateTime.utc(2025, 1, 1),
            calendarStyle: const CalendarStyle(
              selectedDecoration: BoxDecoration(
                color: Colors.green,
                shape: BoxShape.circle,
              ),
              todayDecoration: BoxDecoration(
                color: Colors.lightGreen,
                shape: BoxShape.circle,
              ),
            ),
            onDaySelected: (selectedDay, focusedDay) async {
              setState(() {
                _selectedDay = selectedDay;
                _isLoading = true; // Show loading indicator
              });

              // Fetch attendance and working hours from API
              var data = await AttendanceApi().fetchAttendanceAndWorkingHours(
                date: selectedDay,
                employeeId: 4, // Replace with the actual employee ID
              );

              // Hide loading indicator and show the dialog with data
              setState(() {
                _isLoading = false;
              });

              _showWorkingHoursDialog(context, selectedDay, data);
            },
            selectedDayPredicate: (day) {
              return isSameDay(_selectedDay, day);
            },
          ),
          if (_isLoading) // Display loading indicator when fetching data
            const Expanded(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
    );
  }

  void _showWorkingHoursDialog(
      BuildContext context, DateTime day, Map<String, dynamic> data) {
    List<Map<String, dynamic>> attendance = (data['attendance'] as List)
        .map((e) => {
      "Task": e['event_type'] == 'checkin' ? "Check-In" : "Check-Out",
      "Time": DateFormat.jm().format(DateTime.parse(e['event_time'])),
      "event_time": e['event_time'], // Storing the raw event_time
    })
        .toList();

    // Calculate total working hours programmatically
    Duration totalWorkingHours = Duration.zero;
    DateTime? checkInTime;
    DateTime? checkOutTime;

    for (var entry in data['attendance']) {
      if (entry['event_type'] == 'checkin') {
        checkInTime = DateTime.parse(entry['event_time']);
      } else if (entry['event_type'] == 'checkout') {
        checkOutTime = DateTime.parse(entry['event_time']);
      }


      if (checkInTime != null && checkOutTime != null) {
        totalWorkingHours += checkOutTime.difference(checkInTime);
        checkOutTime = null;
        checkInTime = null;
      }
    }

    // If both check-in and check-out exist, calculate the difference


    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Container(
            width: MediaQuery.of(context).size.width , // 80% of the screen width
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Working Hours for ${DateFormat('dd MMM yyyy').format(day)}",
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                attendance.isNotEmpty
                    ? DataTable(
                  columns: const [
                    DataColumn(label: Text('Task')),
                    DataColumn(label: Text('Time')),
                  ],
                  rows: attendance
                      .map((task) => DataRow(cells: [
                    DataCell(Text(task['Task']!)),
                    DataCell(Text(task['Time']!)),
                  ]))
                      .toList(),
                )
                    : const Text("No attendance data for this day."),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Total Working Hours:",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "${totalWorkingHours.inHours} hours\n ${totalWorkingHours.inMinutes.remainder(60)} minutes",
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    child: const Text('Close'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
