import 'package:flutter/foundation.dart';

@immutable
class Event {
  final String title;
  final DateTime startTime;
  final DateTime endTime;

  const Event({
    required this.title,
    required this.startTime,
    required this.endTime,
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      title: json['title'],
      startTime: DateTime.parse(json['start_time']),
      endTime: DateTime.parse(json['end_time']),
    );
  }
}
