import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ksrvnjord_main_app/src/features/notifications/model/push_notification.dart';
import 'package:firebase_auth/firebase_auth.dart';

final recentNotificationsProvider =
    StreamProvider.family<List<PushNotification>, String>((ref, uid) {
  if (uid.isEmpty) {
    return Stream.value([]);
  }
  return FirebaseFirestore.instance
      .collection('notifications')
      .withConverter<PushNotification>(
        fromFirestore: (snapshot, _) =>
            PushNotification.fromJson(snapshot.data() ?? {}),
        toFirestore: (notification, _) => notification.toJson(),
      )
      .where('topic', whereIn: ['all', 'user_$uid'])
      .where('createdAt',
          isGreaterThanOrEqualTo:
              Timestamp.fromDate(DateTime.now().subtract(Duration(days: 30))))
      .orderBy('createdAt', descending: true)
      .snapshots()
      .map((snapshot) {
        return snapshot.docs.map((doc) => doc.data()).toList();
      });
});

Future<void> markNotificationsAsRead() async {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) {
    throw Exception('User not logged in');
  }

  final uid = user.uid;
  final notificationsQuery = await FirebaseFirestore.instance
      .collection('notifications')
      .where('topic', whereIn: ['all', 'user_$uid'])
      .where('createdAt',
          isGreaterThanOrEqualTo:
              Timestamp.fromDate(DateTime.now().subtract(Duration(days: 30))))
      .get();

  for (final doc in notificationsQuery.docs) {
    await doc.reference.update({
      'readBy': FieldValue.arrayUnion([uid]),
    });
  }
}
