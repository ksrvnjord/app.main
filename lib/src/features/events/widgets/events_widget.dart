import 'package:flutter/material.dart';
import 'package:ksrvnjord_main_app/src/features/events/api/events.graphql.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class EventsWidget extends StatelessWidget {
  const EventsWidget({super.key, required this.data});

  final List<Query$CalendarItems$events?> data;

  static List<Meeting> mapResultToItems(
    List<Query$CalendarItems$events?> events,
  ) {
    return events.map<Meeting>((e) {
      {
        return Meeting(
          e!.toJson()['title'],
          DateTime.parse(e.toJson()['start_time']),
          DateTime.parse(e.toJson()['end_time']),
          Colors.blue,
        );
      }
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return SfCalendar(
      view: CalendarView.schedule,
      minDate: DateTime.now(),
      maxDate: DateTime.now().add(const Duration(days: 365)),
      dataSource: MeetingDataSource(mapResultToItems(data)),
      scheduleViewSettings: const ScheduleViewSettings(
        hideEmptyScheduleWeek: true,
        monthHeaderSettings: MonthHeaderSettings(
          monthFormat: 'MMM yyyy',
          backgroundColor: Colors.transparent,
          height: 60,
          textAlign: TextAlign.center,
          monthTextStyle: TextStyle(
            fontSize: 18,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

class MeetingDataSource extends CalendarDataSource {
  MeetingDataSource(List<Meeting> source) {
    appointments = source;
  }

  @override
  DateTime getStartTime(int index) {
    return _getMeetingData(index).startTime;
  }

  @override
  DateTime getEndTime(int index) {
    return _getMeetingData(index).endTime;
  }

  @override
  String getSubject(int index) {
    return _getMeetingData(index).title;
  }

  @override
  Color getColor(int index) {
    return _getMeetingData(index).color;
  }

  Meeting _getMeetingData(int index) {
    final dynamic meeting = appointments![index];
    late final Meeting meetingData;
    if (meeting is Meeting) {
      meetingData = meeting;
    }

    return meetingData;
  }
}

class Meeting {
  /// Creates a meeting class with required details.
  Meeting(this.title, this.startTime, this.endTime, this.color);

  /// Event name which is equivalent to subject property of [Appointment].
  String title;

  /// From which is equivalent to start time property of [Appointment].
  DateTime startTime;

  /// To which is equivalent to end time property of [Appointment].
  DateTime endTime;

  /// Background which is equivalent to color property of [Appointment].
  Color color;
}
