import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/almanak_profile/api/has_send_birthday_message_provider.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/api/user_provider.dart';

class AlmanakBirthdayButton extends ConsumerWidget {
  const AlmanakBirthdayButton({
    super.key,
    required this.receiverId,
    required this.receiverFullName,
  });
  final String receiverId;
  final String receiverFullName;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hasCongratulatedLidAsyncValue =
        ref.watch(hasSendBirthdayMessageProvider(receiverId));
    final userAsyncVal = ref.watch(currentUserProvider);
    return hasCongratulatedLidAsyncValue.when(
      data: (hasCongratulated) => Padding(
        padding: const EdgeInsets.only(left: 8.0),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: hasCongratulated
                ? Colors.grey // Set background color to grey if not pressable
                : Colors
                    .pinkAccent, // Set background color to pink if pressable
          ),
          onPressed: hasCongratulated
              ? null
              : () async {
                  userAsyncVal.whenData((sender) => _showBirthdayMessageDialog(
                      context, sender.identifierString, sender.fullName));
                },
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.cake, // Add a birthday cake icon
                size: 20,
                color: Colors.white,
              ),
              const SizedBox(width: 8), // Add spacing between icon and text
              hasCongratulated
                  ? Text('Al Gefeliciteerd')
                  : Text(
                      "Verstuur Felicitatie",
                      style: TextStyle(fontSize: 14, color: Colors.white),
                    ),
            ],
          ),
        ),
      ),
      loading: () => const CircularProgressIndicator(),
      error: (error, stack) => Text('Error: $error'),
    );
  }

  void _showBirthdayMessageDialog(
      BuildContext context, String senderId, String senderFullName) async {
    final TextEditingController messageController = TextEditingController();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Felicitatie versturen'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Inhoud bericht:'),
              TextField(
                controller: messageController,
                decoration: const InputDecoration(
                  hintText: 'Typ hier je bericht (max. 50 tekens)',
                ),
                maxLines: null,
                maxLength: 100, // Limit the input to 140 characters
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                // Call the cloud function personalBirthdayMessage
                Navigator.of(context).pop();
              },
              child: const Text('Annuleren'),
            ),
            TextButton(
              onPressed: () async {
                final message = messageController.text.trim();
                final user = FirebaseAuth.instance.currentUser;

                if (user != null) {
                  await _sendBirthdayMessage(
                    context,
                    message,
                    senderId,
                    senderFullName,
                    user,
                  );
                  // ignore: use_build_context_synchronously
                  Navigator.of(context).pop(); // only after message sent
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                          'Je moet ingelogd zijn om een bericht te versturen.'),
                    ),
                  );
                }
              },
              child: const Text('Versturen'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _sendBirthdayMessage(BuildContext context, String message,
      String senderId, String senderFullName, User senderUser) async {
    if (message.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content:
                Text('Geen notificatie gestuurd, bericht mag niet leeg zijn.')),
      );
      return;
    }

    try {
      await FirebaseAuth.instance.currentUser?.getIdToken(true);
      final result = await FirebaseFunctions.instanceFor(region: 'europe-west1')
          .httpsCallable('personalBirthdayMessage')
          .call({
        'receiverId': receiverId,
        'receiverFullName': receiverFullName,
        'senderId': senderId,
        'senderFullName': senderFullName,
        'message': message,
      });

      if (result.data['success'] == true && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Bericht succesvol verstuurd!')),
        );
      } else if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text(
                  'Er is iets  misgegaan bij het versturen. Probeer het later opnieuw.')),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Fout bij versturen: $e')),
        );
      }
    }
  }
}
