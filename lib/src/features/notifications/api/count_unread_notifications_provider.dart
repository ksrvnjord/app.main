import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ksrvnjord_main_app/src/features/notifications/model/push_notification.dart';

final unreadNotificationsCountProvider =
    StreamProvider.family<int, String>((ref, uid) {
  return FirebaseFirestore.instance
      .collection('notifications')
      .withConverter<PushNotification>(
        fromFirestore: (snapshot, _) =>
            PushNotification.fromJson(snapshot.data() ?? {}),
        toFirestore: (answer, _) => answer.toJson(),
      )
      .where('createdAt',
          isGreaterThan:
              Timestamp.fromDate(DateTime.now().subtract(Duration(days: 30))))
      .orderBy('createdAt', descending: true)
      .limit(20)
      .snapshots()
      .map((snapshot) {
    final unread = snapshot.docs.where((doc) {
      final notif = doc.data(); // Automatically converted to Notification

      return !notif.readBy.contains(uid);
    });
    return unread.length;
  });
});
