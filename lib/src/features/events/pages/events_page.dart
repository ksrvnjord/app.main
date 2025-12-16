import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ksrvnjord_main_app/src/features/events/api/events_provider.dart';
import 'package:ksrvnjord_main_app/src/features/events/widgets/events_widget.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/error_card_widget.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/api/user_provider.dart';

class EventsPage extends ConsumerWidget {
  const EventsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final events = ref.watch(comingEventsProvider);
    final currentUserVal = ref.watch(currentUserProvider);
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Agenda'),
      ),
      body: events.when(
        data: (data) => EventsWidget(snapshot: data),
        loading: () => const Center(
          child: CircularProgressIndicator.adaptive(),
        ),
        error: (err, stk) => ErrorCardWidget(errorMessage: err.toString()),
      ),
      // floatingActionButton: currentUserVal.when(
      //   data: (currentUser) => currentUser.isAdmin
      //       ? FloatingActionButton.extended(
      //           tooltip: 'Beheer forms',
      //           foregroundColor: colorScheme.onTertiaryContainer,
      //           backgroundColor: colorScheme.tertiaryContainer,
      //           heroTag: "Manage Forms",
      //           onPressed: () => context.goNamed('Forms -> Manage Forms'),
      //           icon: const Icon(Icons.find_in_page),
      //           label: const Text('Beheer forms'),
      //         )
      //       : null,
      //   loading: () => const SizedBox.shrink(),
      //   error: (e, s) => const SizedBox.shrink(),
      // ),

      floatingActionButton: currentUserVal.when(
        data: (currentUser) {
          final canCreateEvent = currentUser.isAdmin;

          return canCreateEvent
              ? FloatingActionButton.extended(
                  foregroundColor: colorScheme.onTertiaryContainer,
                  backgroundColor: colorScheme.tertiaryContainer,
                  onPressed: () => context.goNamed('Create Event'),
                  icon: const Icon(Icons.add),
                  label: const Text('Nieuw Evenement'),
                )
              : null;
        },
        error: (e, s) {
          FirebaseCrashlytics.instance.recordError(e, s);

          return const SizedBox.shrink();
        },
        loading: () => const SizedBox.shrink(),
      ),
    );
  }
}
