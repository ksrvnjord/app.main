import 'package:flutter/material.dart';
import 'package:ksrvnjord_main_app/src/features/events/models/event.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class EventsWidget extends StatelessWidget {
  const EventsWidget({super.key, required this.data});

  final List<Event> data;

  @override
  Widget build(BuildContext context) {
    return SfCalendar(
      view: CalendarView.schedule,
      minDate: DateTime.now(),
      maxDate: DateTime.now().add(const Duration(days: 365)),
      dataSource: MeetingDataSource(data),
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

  @override
  Color getColor(int index) {
    return Colors.blue;
  }

  Event _meetingData(int index) {
    return appointments![index];
  }
}
