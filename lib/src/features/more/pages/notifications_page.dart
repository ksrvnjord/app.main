import 'package:flutter/material.dart';
import 'package:ksrvnjord_main_app/src/features/more/widgets/notifications_list.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/future_wrapper.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notificaties'),
      ),
      body: FutureWrapper(
        future: Hive.openBox<bool>('topics'),
        success: (topics) => NotificationsList(topics: topics),
      ),
    );
  }
}
