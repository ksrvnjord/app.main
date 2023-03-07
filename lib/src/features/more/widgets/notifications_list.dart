import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:ksrvnjord_main_app/src/features/more/mutations/toggle_topic_fcm.dart';

class NotificationsList extends StatefulWidget {
  final Box topics;

  const NotificationsList({
    Key? key,
    required this.topics,
  }) : super(key: key);

  @override
  State<NotificationsList> createState() => _NotificationsListState();
}

class _NotificationsListState extends State<NotificationsList> {
  void toggleTopic(
    String topic,
    bool value,
    ScaffoldMessengerState messenger,
    String title,
  ) {
    toggleTopicFCM(topic: topic, value: value).then((_) {
      messenger.showSnackBar(SnackBar(
        backgroundColor: Colors.green[900],
        content: Text(
          '${value ? 'Aangemeld' : 'Afgemeld'} voor $title',
        ),
      ));

      setState(() {
        return;
      });
    }).onError((_, __) {
      messenger.showSnackBar(SnackBar(
        backgroundColor: Colors.red[900],
        content: const Text(
          'Er is iets misgegaan',
        ),
      ));

      setState(() {
        return;
      });
    });
  }

  final topics = [
    {'title': 'Schademeldingen', 'topic': 'schade'},
  ];

  @override
  Widget build(BuildContext context) {
    final messenger = ScaffoldMessenger.of(context);

    return ListView(children: <Widget>[
      const SwitchListTile(
        title: Text('Bestuursnotificaties'),
        value: true,
        onChanged: null,
      ),
      const SwitchListTile(
        title: Text('Persoonlijke notificaties'),
        value: true,
        onChanged: null,
      ),
      const Divider(height: 8),
      ...topics
          .map((e) => SwitchListTile(
                title: Text(e['title']!),
                value: widget.topics.get(e['topic']!) ?? false,
                onChanged: (value) => toggleTopic(
                  e['topic']!,
                  value,
                  messenger,
                  e['title']!,
                ),
              ))
          .toList(),
    ]);
  }
}
