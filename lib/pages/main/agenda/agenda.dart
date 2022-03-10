import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class AgendaPage extends StatelessWidget {
  AgendaPage({Key? key}) : super(key: key);

  final List items = [
    {
      'startTime': DateTime(2022, 03, 15, 7, 0, 0),
      'endTime': DateTime(2022, 03, 15, 17, 0, 0),
      'title': 'Roeiwedstrijd',
      'color': Colors.blue,
      //'body': 'Beschrijving van de wedstrijd eventueel met link naar site ofzo'
    },
    {
      'startTime': DateTime(2022, 03, 18, 21, 0, 0),
      'endTime': DateTime(2022, 03, 19, 2, 0, 0),
      'title': 'Feestje',
      'color': Colors.pink,
      //'body': 'Hartstikke gezellig allemaal komen'
    },
    {
      'startTime': DateTime(2022, 03, 22, 17, 26, 0),
      'endTime': DateTime(2022, 03, 22, 23, 59, 0),
      'title': 'ALV',
      'color': Colors.green,
      //'body': 'Hier kan je stemmen over wat er met Njord moet gebeuren.'
    },
    {
      'startTime': DateTime(2022, 04, 1, 9, 0, 0),
      'endTime': DateTime(2022, 04, 1, 15, 0, 0),
      'title': 'Roeiwedstrijd Wedstrijd',
      'color': Colors.blue,
      //'body': 'Beschrijving van de wedstrijd eventueel met link naar site ofzo'
    },
    {
      'startTime': DateTime(2022, 04, 1, 7, 0, 0),
      'endTime': DateTime(2022, 04, 1, 14, 0, 0),
      'title': 'Roeiwedstrijd Competitie',
      'color': Colors.blue,
      //'body': 'Beschrijving van de wedstrijd eventueel met link naar site ofzo'
    },
    {
      'startTime': DateTime(2022, 04, 1, 22, 0, 0),
      'endTime': DateTime(2022, 04, 2, 3, 0, 0),
      'title': 'Feestje II',
      'color': Colors.pink,
      //'body': 'Wat een gezelligheid!!! Trek je leukste costuum aan.'
    },
    {
      'startTime': DateTime(2022, 05, 3, 7, 0, 0),
      'endTime': DateTime(2022, 05, 3, 14, 0, 0),
      'title': 'Roeiwedstrijd III',
      'color': Colors.blue,
      //'body': 'Beschrijving van de wedstrijd eventueel met link naar site ofzo'
    },
    {
      'startTime': DateTime(2022, 05, 7, 22, 0, 0),
      'endTime': DateTime(2022, 05, 8, 3, 0, 0),
      'title': 'Feestje III',
      'color': Colors.pink,
      //'body': 'Wat een gezelligheid!!! Trek je leukste kostuum aan.'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: const Text('Agenda', style: TextStyle(fontSize: 24)),
            backgroundColor: Colors.lightBlue,
            shadowColor: Colors.transparent,
            automaticallyImplyLeading: true,
            systemOverlayStyle:
                const SystemUiOverlayStyle(statusBarColor: Colors.lightBlue)),
        body: SfCalendar(
          view: CalendarView.schedule,
          minDate: DateTime.now(),
          maxDate: DateTime.now().add(const Duration(days: 365)),
          dataSource: MeetingDataSource(_getDataSource()),
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
                      fontWeight: FontWeight.bold))),
        ));
  }

  List<Meeting> _getDataSource() {
    final List<Meeting> meetings = <Meeting>[];
    for (var i = 0; i < items.length; i++) {
      meetings.add(Meeting(items[i]['title'], items[i]['startTime'],
          items[i]['endTime'], items[i]['color']));
    }
    return meetings;
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
