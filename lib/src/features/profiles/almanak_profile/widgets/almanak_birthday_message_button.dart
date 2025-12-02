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
      loading: () => const CircularProgressIndicator.adaptive(),
      error: (error, stack) => Text('Error: $error'),
    );
  }

  void _showBirthdayMessageDialog(
      BuildContext context, String senderId, String senderFullName) async {
    final TextEditingController messageController = TextEditingController();
    bool isLoading = false;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: Text('Felicitatie versturen'),
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Titel bericht:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16, // Make the text a bit larger
                    ),
                  ),
                  Text(
                    'Felicitatie van $senderFullName',
                    style: TextStyle(
                      fontSize: 16, // Make the text a bit larger
                    ),
                  ),
                  const Text(
                    'Inhoud bericht:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16, // Make the text a bit larger
                    ),
                  ),
                  TextField(
                    controller: messageController,
                    decoration: const InputDecoration(
                      hintText: 'Optioneel bericht',
                    ),
                    maxLines: null,
                    maxLength: 100, // Limit the input to 140 characters
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Annuleren'),
                ),
                isLoading
                    ? const CircularProgressIndicator.adaptive()
                    : TextButton(
                        onPressed: () async {
                          final message = messageController.text.trim();
                          final user = FirebaseAuth.instance.currentUser;

                          if (user != null) {
                            setState(() {
                              isLoading = true;
                            });
                            await _sendBirthdayMessage(
                              context,
                              message,
                              senderId,
                              senderFullName,
                              user,
                            );
                            if (context.mounted) {
                              Navigator.of(context)
                                  .pop(); // only after message sent
                            }
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                    'Je moet ingelogd zijn om een bericht te versturen.'),
                              ),
                            );
                          }
                          setState(() {
                            isLoading = false;
                          });
                        },
                        child: const Text('Versturen'),
                      ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _sendBirthdayMessage(BuildContext context, String message,
      String senderId, String senderFullName, User senderUser) async {
    try {
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
                  'Er is iets misgegaan bij het versturen. Probeer het later opnieuw.')),
        );
      }
    } catch (e) {
      if (context.mounted) {
        debugPrint(e.toString());
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Fout bij versturen: $e')),
        );
      }
    }
  }
}
