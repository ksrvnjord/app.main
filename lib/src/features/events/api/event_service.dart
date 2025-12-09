// import 'dart:io';
// import 'dart:ui';

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:ksrvnjord_main_app/src/features/events/models/event.dart';
// import 'package:ksrvnjord_main_app/src/features/profiles/models/user.dart';

// class EventService {
//   static final eventsCollection = FirebaseFirestore.instance
//       .collection('events')
//       // .withConverter<Event>(
//       //   fromFirestore: (snapshot, _) => Event.fromJson(snapshot.data() ?? {}),
//       //   toFirestore: (event, _) => event.toJson(),
//       // );

//   static deleteEvent(DocumentSnapshot<Event> snapshot) async {
//     final event = snapshot.data();

//     // if (event?.imageRef != null) {
//     //   await event?.imageRef?.delete();
//     // }
//     snapshot.reference.delete();
//   }

//   static like(DocumentSnapshot<Event> snapshot) {
//     final uid = firebase_auth.FirebaseAuth.instance.currentUser?.uid;
//     final event = snapshot.data();
//   }

//   static Future<void> create({
//     required String title,
//     required String description,
//     required Timestamp startTime,
//     required Timestamp endTime,
//     required Color color,
//   }) async {
//     final eventRef = eventsCollection.doc(); // Make a new document reference.
  
//     await eventRef.set(
//       Event(
//         title: title,
//         description: description,
//         startTime: startTime,
//         endTime: endTime,
//         color: color,
//       ),
//     );
    
//   }
// }

import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:ksrvnjord_main_app/src/features/events/models/event.dart';

class EventService {
  static final eventsCollection = FirebaseFirestore.instance
      .collection('events');

  static Future<void> deleteEvent(DocumentSnapshot<Event> snapshot) async {
    await snapshot.reference.delete();
  }

  static Future<void> create({
    required String title,
    required String description,
    required Timestamp startTime,
    required Timestamp endTime,
    required Color color,
  }) async {
    final eventRef = eventsCollection.doc();

    await eventRef.set({
      'title': title,
      'description': description,
      'start_time': startTime,
      'end_time': endTime,
      'type': _getTypeFromColor(color),
    });
  }

  /// Determine event type from color
  static String _getTypeFromColor(Color color) {
    if (color == const Color(0xFF008200)) return 'borrel';
    if (color == const Color(0xFF1565C0)) return 'wedstrijd';
    if (color == const Color(0xFFC62828)) return 'competitie';
    return 'overig';
  }
}