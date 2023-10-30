import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ksrvnjord_main_app/src/features/announcements/model/announcement.dart';
import 'package:ksrvnjord_main_app/src/features/authentication/model/providers/firebase_auth_user_provider.dart';

// Get first page of announcements.
// For now we have one provider for announcements, when we have multiple consider putting them in a class.
// ignore: prefer-static-class
@immutable
abstract class Announcements {
  static final firstTenProvider =
      FutureProvider.autoDispose<QuerySnapshot<Announcement>>(
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
      FutureProvider.autoDispose.family<DocumentSnapshot<Announcement>, String>(
    (ref, announcementId) {
      // ignore: avoid-ignoring-return-values
      ref.watch(firebaseAuthUserProvider);

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
