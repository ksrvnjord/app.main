// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

@immutable
class Event {
  static final firestoreConverter = FirebaseFirestore.instance
      .collection('events')
      .withConverter<Event>(
        fromFirestore: (snapshot, _) => Event.fromMap(snapshot.data() ?? {}),
        toFirestore: (event, _) => event.toMap(),
      );

  final String title;
  final Timestamp startTime;
  final Timestamp endTime;
  final Color? color;

  const Event({
    required this.title,
    required this.startTime,
    required this.endTime,
    this.color,
  });

  factory Event.fromMap(Map<String, dynamic> map) {
    return Event(
      title: map['title'] as String,
      startTime: map['start_time'] as Timestamp,
      endTime: map['end_time'] as Timestamp,
      color: map['color'] != null ? Color(map['color'] as int) : null,
    );
  }

  Event copyWith({
    String? title,
    Timestamp? startTime,
    Timestamp? endTime,
    required Color color,
  }) {
    return Event(
      title: title ?? this.title,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      color: color,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'title': title,
      'start_time': startTime,
      'end_time': endTime,
      'color': color?.value,
    };
  }
}
