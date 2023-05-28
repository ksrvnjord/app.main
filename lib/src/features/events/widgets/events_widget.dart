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

    final textTheme = Theme.of(context).textTheme;

    return SfCalendar(
      // TODO: on darkmode this doesn't look right yet.
      view: CalendarView.schedule,
      backgroundColor: colorScheme.background,
      dataSource: MeetingDataSource(data),
      headerStyle: CalendarHeaderStyle(
        backgroundColor: colorScheme.primaryContainer,
        textStyle: textTheme.titleMedium ?? const TextStyle(),
      ),
      scheduleViewSettings: ScheduleViewSettings(
        hideEmptyScheduleWeek: true,
        monthHeaderSettings: MonthHeaderSettings(
          monthFormat: 'MMMM',
          height: bodyMonthHeaderHeight,
          backgroundColor: colorScheme.secondaryContainer,
          monthTextStyle: textTheme.titleMedium ?? const TextStyle(),
        ),
      ),
      minDate: DateTime.now(),
      maxDate: DateTime.now().add(const Duration(days: 365)),
      appointmentTextStyle: textTheme.bodyMedium ?? const TextStyle(),
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
