import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ksrvnjord_main_app/src/features/authentication/model/providers/firebase_auth_user_provider.dart';
import 'package:ksrvnjord_main_app/src/features/notifications/api/recent_notifications_provider.dart';
import 'package:ksrvnjord_main_app/src/features/notifications/widgets/push_notification_widget.dart';

class ListNotificationsPage extends ConsumerStatefulWidget {
  const ListNotificationsPage({super.key});

  @override
  ListNotificationsPageState createState() => ListNotificationsPageState();
}

class ListNotificationsPageState extends ConsumerState<ListNotificationsPage> {
  // Function that should be called when the page is exited

  Future<void> markNotificationsAsRead() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw Exception('User not logged in');
    }

    final uid = user.uid;
    final notificationsQuery = await FirebaseFirestore.instance
        .collection('notifications')
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

  @override
  void dispose() {
    markNotificationsAsRead();
    super.dispose(); // Don't forget to call the super dispose method
  }

  @override
  Widget build(BuildContext context) {
    final notificationsAsyncValue = ref.watch(recentNotificationsProvider);
    final currentUser = ref.watch(firebaseAuthUserProvider).value;

    return Scaffold(
      appBar: AppBar(
        title: Text('Berichten'),
      ),
      body: notificationsAsyncValue.when(
        data: (notifications) {
          if (notifications.isEmpty) {
            return Center(
              child: Text(
                'No notifications yet!',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            );
          }
          return ListView.builder(
            itemCount: notifications.length,
            itemBuilder: (context, index) {
              final notification = notifications[index];
              return PushNotificationWidget(
                  notification: notification, uid: currentUser?.uid);
            },
          );
        },
        loading: () => Center(child: CircularProgressIndicator.adaptive()),
        error: (error, stack) => Center(
          child: Text(
            'Failed to load notifications',
            style: TextStyle(fontSize: 18, color: Colors.red),
          ),
        ),
      ),
    );
  }
}
