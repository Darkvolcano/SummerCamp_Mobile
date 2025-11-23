import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:summercamp/core/config/staff_theme.dart';
import 'package:summercamp/features/schedule/domain/entities/schedule.dart';

class ScheduleCalendar extends StatefulWidget {
  final List<Schedule> schedules;

  const ScheduleCalendar({super.key, required this.schedules});

  @override
  State<ScheduleCalendar> createState() => _ScheduleCalendarState();
}

class _ScheduleCalendarState extends State<ScheduleCalendar> {
  late final ValueNotifier<List<Schedule>> _selectedEvents;
  LinkedHashMap<DateTime, List<Schedule>>? _kEvents;

  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
    _initEvents();
    _selectedEvents = ValueNotifier(_getEventsForDay(_selectedDay!));
  }

  @override
  void didUpdateWidget(covariant ScheduleCalendar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.schedules != oldWidget.schedules) {
      _initEvents();
      _selectedEvents.value = _getEventsForDay(_selectedDay!);
    }
  }

  @override
  void dispose() {
    _selectedEvents.dispose();
    super.dispose();
  }

  void _initEvents() {
    final events = <DateTime, List<Schedule>>{};

    for (var schedule in widget.schedules) {
      try {
        final start = DateTime.parse(schedule.startDate);
        final end = DateTime.parse(schedule.endDate);

        DateTime currentDay = start;
        while (!currentDay.isAfter(end)) {
          final keyDay = DateTime(
            currentDay.year,
            currentDay.month,
            currentDay.day,
          );

          if (events[keyDay] == null) {
            events[keyDay] = [];
          }
          events[keyDay]!.add(schedule);

          currentDay = currentDay.add(const Duration(days: 1));
        }
      } catch (e) {
        print("Lỗi parse ngày trong ScheduleCalendar: $e");
      }
    }

    _kEvents = LinkedHashMap<DateTime, List<Schedule>>(
      equals: isSameDay,
      hashCode: getHashCode,
    )..addAll(events);
  }

  List<Schedule> _getEventsForDay(DateTime day) {
    return _kEvents?[day] ?? [];
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
      });

      _selectedEvents.value = _getEventsForDay(selectedDay);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TableCalendar<Schedule>(
          locale: 'vi_VN',
          firstDay: DateTime.utc(2024, 1, 1),
          lastDay: DateTime.utc(2030, 12, 31),
          focusedDay: _focusedDay,
          selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
          eventLoader: _getEventsForDay,
          startingDayOfWeek: StartingDayOfWeek.monday,

          calendarStyle: CalendarStyle(
            markerDecoration: const BoxDecoration(
              color: Colors.lightGreen,
              shape: BoxShape.circle,
            ),
            todayDecoration: BoxDecoration(
              color: StaffTheme.staffAccent.withValues(alpha: 0.5),
              shape: BoxShape.circle,
            ),
            selectedDecoration: const BoxDecoration(
              color: StaffTheme.staffPrimary,
              shape: BoxShape.circle,
            ),
          ),

          headerStyle: const HeaderStyle(
            formatButtonVisible: false,
            titleCentered: true,
            titleTextStyle: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              fontFamily: "Quicksand",
              color: StaffTheme.staffPrimary,
            ),
          ),

          onDaySelected: _onDaySelected,
        ),

        const Divider(),

        ValueListenableBuilder<List<Schedule>>(
          valueListenable: _selectedEvents,
          builder: (context, value, _) {
            if (value.isEmpty) {
              return const Padding(
                padding: EdgeInsets.all(16.0),
                child: Center(
                  child: Text(
                    'Không có lịch trình.',
                    style: TextStyle(
                      fontFamily: "Quicksand",
                      color: Colors.grey,
                    ),
                  ),
                ),
              );
            }

            return ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: value.length,
              itemBuilder: (context, index) {
                final schedule = value[index];
                return Card(
                  shadowColor: Colors.white.withValues(alpha: 0.0),
                  margin: const EdgeInsets.symmetric(
                    vertical: 4,
                    horizontal: 8,
                  ),
                  child: ListTile(
                    leading: const Icon(
                      Icons.event,
                      color: StaffTheme.staffPrimary,
                    ),
                    title: Text(
                      schedule.name,
                      style: const TextStyle(
                        fontFamily: "Quicksand",
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      schedule.place,
                      style: const TextStyle(
                        fontFamily: "Quicksand",
                        fontSize: 12,
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ],
    );
  }
}

int getHashCode(DateTime key) {
  return key.day * 1000000 + key.month * 10000 + key.year;
}
