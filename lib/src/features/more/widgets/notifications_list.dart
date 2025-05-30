// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:ksrvnjord_main_app/src/features/more/mutations/toggle_topic_fcm.dart';
import 'package:styled_widget/styled_widget.dart';

class NotificationsList extends StatefulWidget {
  const NotificationsList({
    super.key,
    required this.topics,
  });

  final Box topics;

  @override
  State<NotificationsList> createState() => _NotificationsListState();
}

class _NotificationsListState extends State<NotificationsList> {
  void toggleTopic(
    String topic,
    bool value,
    ScaffoldMessengerState messenger,
    String title,
  ) async {
    final colorScheme = Theme.of(context).colorScheme;
    try {
      await toggleTopicFCM(topic: topic, value: value);
      // ignore: avoid-ignoring-return-values
      messenger.showSnackBar(SnackBar(
        content: Text('${value ? 'Aangemeld' : 'Afgemeld'} voor $title'),
      ));
    } catch (e) {
      // ignore: avoid-ignoring-return-values
      messenger.showSnackBar(SnackBar(
        content: const Text(
          'Er is iets misgegaan',
        ).textColor(colorScheme.onErrorContainer),
        backgroundColor: colorScheme.errorContainer,
      ));
    }
    if (mounted) {
      setState(() {
        return;
      });
    }
  }

  final topics = [
    {'title': 'Schademeldingen', 'topic': 'schade'},
  ];

  @override
  Widget build(BuildContext context) {
    final messenger = ScaffoldMessenger.of(context);

    return ListView(children: <Widget>[
      const SwitchListTile(
        value: true,
        onChanged: null,
        title: Text('Bestuursnotificaties'),
        visualDensity: VisualDensity.standard,
      ),
      const SwitchListTile(
        value: true,
        onChanged: null,
        title: Text('Persoonlijke notificaties'),
        visualDensity: VisualDensity.standard,
      ),
      const Divider(height: 0),
      ...topics.map((e) {
        // Retrieve the current state from the Hive box
        bool isChecked = widget.topics.get(e['topic']!) ?? false;

        return SwitchListTile(
          value: isChecked,
          onChanged: (value) {
            setState(() {
              // Update the state in the Hive box
              widget.topics.put(e['topic']!, value);
            });

            // Optionally call toggleTopic to handle additional logic
            toggleTopic(e['topic']!, value, messenger, e['title']!);
          },
          title: Text(e['title']!),
          visualDensity: VisualDensity.standard,
        );
      }),
    ]);
  }
}
