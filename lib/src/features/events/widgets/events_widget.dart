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

    final events = snapshot.docs.map(
        // Set color for every event to the primary color.
        (snap) => snap.data()).toList();

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
      // Add onTap callback to handle event taps
      onTap: (CalendarTapDetails details) {
        if (details.targetElement == CalendarElement.appointment && 
            details.appointments != null && 
            details.appointments!.isNotEmpty) {
          final Event tappedEvent = details.appointments!.first as Event;
          _showEventDescription(context, tappedEvent);
        }
      },
    );
  }

  // Function to show event description in a dialog
  void _showEventDescription(BuildContext context, Event event) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(event.title),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (event.description.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text(event.description),
                  const SizedBox(height: 16),
                ],
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
          ],
        );
      },
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
