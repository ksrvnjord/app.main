import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ksrvnjord_main_app/src/features/authentication/model/providers/firebase_auth_user_provider.dart';
import 'package:ksrvnjord_main_app/src/features/notifications/api/count_unread_notifications_provider.dart';

class NotificationHomePageWidget extends ConsumerWidget {
  const NotificationHomePageWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(firebaseAuthUserProvider).value;

    if (currentUser == null) {
      return const SizedBox.shrink();
    }
    final unreadCountAsync =
        ref.watch(unreadNotificationsCountProvider(currentUser.uid));

    return unreadCountAsync.when(
      loading: () => IconButton(
        icon: Icon(Icons.notifications),
        onPressed: null,
      ),
      error: (e, st) {
        debugPrint('Error: $e');
        debugPrint('StackTrace: $st');
        return const Icon(Icons.error);
      },
      data: (count) {
        return Stack(
          alignment: Alignment.center,
          children: [
            Icon(
              count > 0
                  ? Icons.notifications_active
                  : Icons.notifications, // Active or normal bell icon
              size: 26, // Adjust the size as per your needs
            ),
            if (count > 0)
              Positioned(
                right: 0, // Position the dot at the bottom-right corner
                bottom: 0,
                child: Container(
                  padding: const EdgeInsets.all(0),
                  decoration: BoxDecoration(
                    color: Colors.red, // Red background for the dot
                    shape: BoxShape.circle,
                  ),
                  constraints: const BoxConstraints(
                    minWidth: 12, // Small dot
                    minHeight: 12,
                  ),
                  child: Text(
                    '$count',
                    style: const TextStyle(
                      color: Colors.white, // White text color
                      fontSize: 8, // Smaller font size for the number
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
