import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ksrvnjord_main_app/src/features/events/models/event.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class EventsWidget extends StatelessWidget {
  const EventsWidget({super.key, required this.snapshot});

  final QuerySnapshot<Event> snapshot;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    const double bodyMonthHeaderHeight = 56;

    final events = snapshot.docs
        .map(
          // Set color for every event to the primary color.
          (snap) => snap.data().copyWith(color: colorScheme.primaryContainer),
        )
        .toList();

    final textTheme = Theme.of(context).textTheme;

    return SfCalendar(
      view: CalendarView.schedule,
      backgroundColor: colorScheme.surface,
      dataSource: MeetingDataSource(events),
      headerStyle: CalendarHeaderStyle(
        textStyle: textTheme.titleLarge ?? const TextStyle(),
      ),
      scheduleViewSettings: ScheduleViewSettings(
        appointmentTextStyle: textTheme.bodyMedium
                ?.copyWith(color: colorScheme.onPrimaryContainer) ??
            const TextStyle(),
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
    );
  }
}

class MeetingDataSource extends CalendarDataSource {
  MeetingDataSource(List<Event> source) {
    appointments = source;
  }

  @override
  DateTime getStartTime(int index) {
    return _meetingData(index).startTime.toDate();
  }

  @override
  DateTime getEndTime(int index) {
    return _meetingData(index).endTime.toDate();
  }

  @override
  Color getColor(int index) {
    return _meetingData(index).color ?? Colors.white;
  }

  @override
  String getSubject(int index) {
    return _meetingData(index).title;
  }

  Event _meetingData(int index) {
    return appointments?[index];
  }
}
