import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ksrvnjord_main_app/src/features/events/api/events_provider.dart';
import 'package:ksrvnjord_main_app/src/features/events/widgets/events_widget.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/error_card_widget.dart';

class EventsPage extends ConsumerWidget {
  const EventsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final events = ref.watch(comingEventsProvider);

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
    );
  }
}
