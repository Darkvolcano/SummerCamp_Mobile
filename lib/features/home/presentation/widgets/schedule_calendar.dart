import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../../../core/config/staff_theme.dart';

class ScheduleCalendar extends StatefulWidget {
  const ScheduleCalendar({super.key});

  @override
  State<ScheduleCalendar> createState() => _ScheduleCalendarState();
}

class _ScheduleCalendarState extends State<ScheduleCalendar> {
  List<ScheduleRecord> scheduleRecords = [
    ScheduleRecord(date: DateTime.now(), isPresent: true),
    ScheduleRecord(
      date: DateTime.now().subtract(const Duration(days: 1)),
      isPresent: false,
    ),
  ];

  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  Map<DateTime, List<ScheduleRecord>> _getEventsForDay() {
    Map<DateTime, List<ScheduleRecord>> events = {};
    for (var record in scheduleRecords) {
      final date = DateTime(
        record.date.year,
        record.date.month,
        record.date.day,
      );
      events.putIfAbsent(date, () => []).add(record);
    }
    return events;
  }

  List<ScheduleRecord> _getRecordsForSelectedDay() {
    if (_selectedDay == null) return scheduleRecords;
    final selectedDate = DateTime(
      _selectedDay!.year,
      _selectedDay!.month,
      _selectedDay!.day,
    );
    return scheduleRecords.where((record) {
      final recordDate = DateTime(
        record.date.year,
        record.date.month,
        record.date.day,
      );
      return isSameDay(recordDate, selectedDate);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final events = _getEventsForDay();
    final selectedRecords = _getRecordsForSelectedDay();

    return Column(
      children: [
        TableCalendar(
          locale: 'vi_VN',
          firstDay: DateTime(2020),
          lastDay: DateTime(2030),
          focusedDay: _focusedDay,
          selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
          onDaySelected: (selectedDay, focusedDay) {
            setState(() {
              _selectedDay = selectedDay;
              _focusedDay = focusedDay;
            });
          },
          eventLoader: (day) {
            final date = DateTime(day.year, day.month, day.day);
            return events[date] ?? [];
          },

          calendarStyle: CalendarStyle(
            todayDecoration: BoxDecoration(
              color: StaffTheme.staffAccent.withValues(alpha: 0.7),
              shape: BoxShape.circle,
            ),
            selectedDecoration: BoxDecoration(
              color: StaffTheme.staffPrimary,
              shape: BoxShape.circle,
            ),
            markerDecoration: BoxDecoration(
              color: StaffTheme.staffPrimary.withValues(alpha: 0.8),
              shape: BoxShape.circle,
            ),
            weekendTextStyle: const TextStyle(color: Colors.red),
            defaultTextStyle: const TextStyle(
              fontFamily: "Nunito",
              fontWeight: FontWeight.w600,
            ),
          ),

          headerStyle: HeaderStyle(
            formatButtonVisible: false,
            titleCentered: true,
            titleTextFormatter: (date, locale) =>
                DateFormat.yMMMM(locale).format(date),
            titleTextStyle: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              fontFamily: "Fredoka",
              color: StaffTheme.staffPrimary,
            ),
            leftChevronIcon: Icon(
              Icons.chevron_left,
              color: StaffTheme.staffPrimary,
              size: 28,
            ),
            rightChevronIcon: Icon(
              Icons.chevron_right,
              color: StaffTheme.staffPrimary,
              size: 28,
            ),
          ),

          calendarBuilders: CalendarBuilders(
            markerBuilder: (context, date, events) {
              if (events.isNotEmpty) {
                final record = events.first as ScheduleRecord;
                return Positioned(
                  bottom: 4,
                  child: Icon(
                    record.isPresent ? Icons.check_circle : Icons.cancel,
                    size: 18.0,
                    color: record.isPresent ? Colors.green : Colors.red,
                  ),
                );
              }
              return null;
            },
          ),
        ),

        const SizedBox(height: 12),

        Expanded(
          child: selectedRecords.isEmpty
              ? const Center(
                  child: Text(
                    'Không có bản ghi nào.',
                    style: TextStyle(fontFamily: "Nunito"),
                  ),
                )
              : ListView.builder(
                  itemCount: selectedRecords.length,
                  itemBuilder: (context, index) {
                    final record = selectedRecords[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(
                        vertical: 6,
                        horizontal: 8,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        leading: Icon(
                          record.isPresent ? Icons.check_circle : Icons.cancel,
                          color: record.isPresent ? Colors.green : Colors.red,
                        ),
                        title: Text(
                          DateFormat('dd/MM/yyyy HH:mm').format(record.date),
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontFamily: "Nunito",
                          ),
                        ),
                        subtitle: Text(
                          record.isPresent ? 'Có mặt' : 'Vắng mặt',
                          style: TextStyle(
                            fontFamily: "Nunito",
                            color: record.isPresent ? Colors.green : Colors.red,
                          ),
                        ),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }
}

class ScheduleRecord {
  final DateTime date;
  final bool isPresent;

  ScheduleRecord({required this.date, required this.isPresent});
}
