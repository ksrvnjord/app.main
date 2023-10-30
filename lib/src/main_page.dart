import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ksrvnjord_main_app/src/features/messaging/init_messaging_info.dart';
import 'package:ksrvnjord_main_app/src/features/messaging/request_messaging_permission.dart';
import 'package:ksrvnjord_main_app/src/features/messaging/save_messaging_token.dart';
import 'package:ksrvnjord_main_app/src/features/shared/model/firebase_user_notifier.dart';

class MainPage extends ConsumerWidget {
  const MainPage({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  void onStartup(WidgetRef ref) {
    // ignore: avoid-ignoring-return-values

    final user = ref.read(
      currentFirestoreUserProvider,
    ); // Get currentUser details from firebase.

    if (!kIsWeb && user != null) {
      // Web does not support messaging, also user should be logged in to Firebase for it to work.
      requestMessagingPermission(); // TODO: Only prompt if the user is able to give permission, ie. not when user already gave permissies or denied them.
      saveMessagingToken(); // TODO: Retry on no internet connection.
      initMessagingInfo();
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    onStartup(ref);
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_filled),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_outlined),
            label: 'Prikbord',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.edit_calendar),
            label: 'Afschrijven',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.book), label: 'Almanak'),
          BottomNavigationBarItem(icon: Icon(Icons.more_horiz), label: 'Meer'),
        ],
        onTap: (value) => animateTo(value),
        currentIndex: navigationShell.currentIndex,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: colorScheme.primary,
      ),
    );
  }

  void animateTo(int index) {
    navigationShell.goBranch(
      index,
      // A common pattern when using bottom navigation bars is to support
      // navigating to the initial location when tapping the item that is
      // already active. This example demonstrates how to support this behavior,
      // using the initialLocation parameter of goBranch.
      initialLocation: index == navigationShell.currentIndex,
    );
  }
}
