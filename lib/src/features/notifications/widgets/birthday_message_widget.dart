import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ksrvnjord_main_app/src/features/notifications/api/birthday_messages_provider.dart';

class BirthdayMessageWidget extends StatelessWidget {
  const BirthdayMessageWidget({
    super.key,
    required this.message,
  });

  final BirthdayMessage message;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 12.0),
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: Colors.pink.shade100,
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title with cake icon
          Row(
            children: [
              const Icon(
                Icons.cake,
                color: Colors.pink,
                size: 20,
              ),
              const SizedBox(width: 8.0),
              Flexible(
                child: Text(
                  message.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8.0),

          // Message body
          Text(
            message.message,
            style: const TextStyle(fontSize: 14, color: Colors.black87),
          ),
          const SizedBox(height: 6.0),

          // Timestamp
          Text(
            DateFormat.yMMMd().add_Hm().format(message.sentAt),
            style: const TextStyle(
              fontSize: 12,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
