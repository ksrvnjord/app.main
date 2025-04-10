import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ksrvnjord_main_app/src/features/notifications/model/push_notification.dart';
import 'package:ksrvnjord_main_app/src/features/shared/model/dio_provider.dart';

class CreatePushNotificationPage extends ConsumerStatefulWidget {
  const CreatePushNotificationPage({super.key});

  @override
  CreatePushNotificationPageState createState() =>
      CreatePushNotificationPageState();
}

class CreatePushNotificationPageState
    extends ConsumerState<CreatePushNotificationPage> {
  final _formKey = GlobalKey<FormState>();
  String _title = '';
  String _message = '';
  final String _topic = 'all';

  void _submitForm() {
    final currentState = _formKey.currentState;
    if (currentState != null && currentState.validate()) {
      // ignore: avoid-ignoring-return-values
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Wil je echt een push notificatie sturen naar $_topic?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Annuleer'),
            ),
            ElevatedButton(
              // ignore: prefer-extracting-callbacks
              onPressed: () async {
                final dio = ref.watch(dioProvider);

                // Send push notification
                await dio.post(
                  "/api/social/notification/",
                  data: {
                    "title": _title,
                    "body": _message,
                    "topic": _topic,
                    "confirm": true,
                  },
                );

                // Create an entry in Firestore
                final firestore = FirebaseFirestore.instance;
                await firestore.collection('notifications').add(
                      PushNotification(
                        title: _title,
                        body: _message,
                        topic: _topic,
                        createdAt: Timestamp.now(),
                        readBy: [],
                      ).toJson(),
                    );

                // Show confirmation message
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content:
                        Text("Push notificatie is verstuurd en opgeslagen."),
                  ),
                );

                Navigator.of(context).pop();
              },
              child: const Text('Verstuur'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Stuur Push Notificatie'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'Titel'),
                onChanged: (value) => setState(() {
                  _title = value;
                }),
                // ignore: prefer-extracting-callbacks
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Voer een titel in';
                  }

                  return null;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Bericht'),
                onChanged: (value) => setState(() {
                  _message = value;
                }),
                // ignore: prefer-extracting-callbacks
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Voer een bericht in';
                  }

                  return null;
                },
              ),
              TextFormField(
                initialValue: _topic,
                decoration: const InputDecoration(labelText: 'Ontvangers'),
                readOnly: true,
                enabled: false,
              ),
            ],
          ),
        ),
      ),
      // ignore: arguments-ordering
      floatingActionButton: FloatingActionButton(
        onPressed: _submitForm,
        child: const Icon(Icons.send),
      ),
    );
  }
}
