import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ksrvnjord_main_app/src/features/announcements/model/announcement.dart';

// Get first page of announcements.
// For now we have one provider for announcements, when we have multiple consider putting them in a class.
// ignore: prefer-static-class
@immutable
abstract class Announcements {
  static final firstTenProvider = FutureProvider<QuerySnapshot<Announcement>>(
    (ref) {
      return FirebaseFirestore.instance
          .collection('announcements')
          .withConverter<Announcement>(
            fromFirestore: (snapshot, _) =>
                Announcement.fromMap(snapshot.data() ?? {}),
            toFirestore: (announcement, _) => announcement.toMap(),
          )
          .orderBy('created_at', descending: true)
          .limit(10)
          .get();
    },
  );

  static final byIdProvider =
      FutureProvider.family<DocumentSnapshot<Announcement>, String>(
    (ref, announcementId) {
      return FirebaseFirestore.instance
          .collection('announcements')
          .doc(announcementId)
          .withConverter<Announcement>(
            fromFirestore: (snapshot, _) =>
                Announcement.fromMap(snapshot.data() ?? {}),
            toFirestore: (announcement, _) => announcement.toMap(),
          )
          .get();
    },
  );
}
