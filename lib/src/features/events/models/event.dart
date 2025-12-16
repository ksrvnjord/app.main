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
  final String description;
  final Timestamp startTime;
  final Timestamp endTime;
  final Color? color;

  const Event({
    required this.title,
    required this.startTime,
    required this.endTime,
    this.description = "",
    this.color,
  });

  factory Event.fromMap(Map<String, dynamic> map) {
    // Define a mapping of types to colors
    final typeColorMapping = {
      'borrel': Color(0xFF008200), // Example color for 'borrel'
      'wedstrijd': Color(0xFF1565C0), // Example color for 'wedstrijd'
      'competitie': Color(0xFFC62828), // Example color for 'competitie'
      'overig': Color(0xFFB8860B), // Example color for 'overig'
    };

    // Get the type from the map and use the mapping to get the color
    final type = map['type'] as String?;
    final color = typeColorMapping[type] ??
        Color(0xFFB8860B); // Default color for null or other types

    return Event(
      title: map['title'] as String,
      startTime: map['start_time'] as Timestamp,
      endTime: map['end_time'] as Timestamp,
      color: color,
      description: map['description'] as String? ?? "",
    );
  }

  Event copyWith({
    String? title,
    Timestamp? startTime,
    Timestamp? endTime,
    String? description,
    required Color color,
  }) {
    return Event(
      title: title ?? this.title,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      description: description ?? this.description,
      color: color,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'title': title,
      'start_time': startTime,
      'end_time': endTime,
      'description': description,
      'color': color?.value,
    };
  }
}
