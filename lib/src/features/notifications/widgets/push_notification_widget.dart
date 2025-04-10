import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ksrvnjord_main_app/src/features/notifications/model/push_notification.dart';

class PushNotificationWidget extends StatelessWidget {
  const PushNotificationWidget(
      {super.key, required this.notification, required this.uid});
  final PushNotification notification;
  final String? uid;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
        side: BorderSide(color: Colors.grey.shade300, width: 1),
      ),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Title
                Text(
                  notification.title,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                // "Nieuw" text in line with the title
                if (uid != null && !notification.readBy.contains(uid!))
                  Text(
                    'Nieuw',
                    style: const TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 8.0),

            // Body of the notification
            Text(notification.body,
                style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 12.0),

            // Date formatted properly
            Text(
                'Date: ${DateFormat.yMMMd().format(notification.createdAt.toDate())}',
                style: Theme.of(context).textTheme.bodyMedium),
          ],
        ),
      ),
    );
  }
}
