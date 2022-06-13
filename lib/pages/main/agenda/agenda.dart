import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:graphql/client.dart';
import 'package:ksrvnjord_main_app/providers/heimdall.dart';
import 'package:ksrvnjord_main_app/widgets/ui/general/loading.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class AgendaPage extends HookConsumerWidget {
  AgendaPage({Key? key}) : super(key: key);

  final QueryOptions options = QueryOptions(document: gql('''
      query CalendarItems {
        events {
          id,
          title,
          start_time,
          end_time
        }
      }
    '''));

  static List<Meeting> mapResultToItems(QueryResult result) {
    if ((result.data != null) && (result.data!['events'] != null)) {
      List<dynamic> events = result.data!['events'];
      return events
          .map<Meeting>((e) => Meeting(
              e['title'],
              DateTime.parse(e['start_time']),
              DateTime.parse(e['end_time']),
              Colors.blue))
          .toList();
    }
    return [];
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final GraphQLClient client = ref.watch(heimdallProvider).graphQLClient();
    final Future<QueryResult> result = client.query(options);

    return FutureBuilder(
        future: result,
        builder: (BuildContext context, AsyncSnapshot<QueryResult> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
              return const Text('not started');
            case ConnectionState.waiting:
              return const Loading();
            default:
              return Scaffold(
                  appBar: AppBar(
                      title:
                          const Text('Agenda', style: TextStyle(fontSize: 24)),
                      backgroundColor: Colors.lightBlue,
                      shadowColor: Colors.transparent,
                      automaticallyImplyLeading: true,
                      systemOverlayStyle: const SystemUiOverlayStyle(
                          statusBarColor: Colors.lightBlue)),
                  body: SfCalendar(
                    view: CalendarView.schedule,
                    minDate: DateTime.now(),
                    maxDate: DateTime.now().add(const Duration(days: 365)),
                    dataSource: snapshot.hasData
                        ? MeetingDataSource(mapResultToItems(snapshot.data!))
                        : null,
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
        });
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
