import 'package:flutter/material.dart';
import 'package:ksrvnjord_main_app/src/features/events/models/event.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class EventsWidget extends StatelessWidget {
  const EventsWidget({super.key, required this.data});

  final List<Event> data;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    const double bodyMonthHeaderHeight = 56;

    return SfCalendar(
      view: CalendarView.schedule,
      dataSource: MeetingDataSource(data),
      headerStyle: CalendarHeaderStyle(
        backgroundColor: colorScheme.primaryContainer,
        textStyle: const TextStyle(
          color: Colors.black,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      scheduleViewSettings: ScheduleViewSettings(
        hideEmptyScheduleWeek: true,
        monthHeaderSettings: MonthHeaderSettings(
          monthFormat: 'MMMM',
          height: bodyMonthHeaderHeight,
          backgroundColor: colorScheme.secondaryContainer,
          monthTextStyle: const TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      minDate: DateTime.now(),
      maxDate: DateTime.now().add(const Duration(days: 365)),
    );
  }
}

class MeetingDataSource extends CalendarDataSource {
  MeetingDataSource(List<Event> source) {
    appointments = source;
  }

  @override
  DateTime getStartTime(int index) {
    return _meetingData(index).startTime;
  }

  @override
  DateTime getEndTime(int index) {
    return _meetingData(index).endTime;
  }

  @override
  String getSubject(int index) {
    return _meetingData(index).title;
  }

  Event _meetingData(int index) {
    return appointments?[index];
  }
}
