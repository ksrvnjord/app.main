// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:ui';

import 'package:flutter/foundation.dart';

@immutable
class Event {
  final String title;
  final DateTime startTime;
  final DateTime endTime;
  final Color? color;

  const Event({
    required this.title,
    required this.startTime,
    required this.endTime,
    this.color,
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      title: json['title'],
      startTime: DateTime.parse(json['start_time']),
      endTime: DateTime.parse(json['end_time']),
      color: json['color'] != null ? Color(json['color']) : null,
    );
  }

  Event copyWith({
    String? title,
    DateTime? startTime,
    DateTime? endTime,
    required Color color,
  }) {
    return Event(
      title: title ?? this.title,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      color: color,
    );
  }
}
