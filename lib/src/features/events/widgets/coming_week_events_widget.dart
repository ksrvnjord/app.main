import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ksrvnjord_main_app/src/features/dashboard/widgets/widget_header.dart';
import 'package:ksrvnjord_main_app/src/features/events/api/events_provider.dart';
import 'package:ksrvnjord_main_app/src/features/events/models/event.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/error_card_widget.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/fade_bottom_widget.dart';
import 'package:routemaster/routemaster.dart';
import 'package:styled_widget/styled_widget.dart';
import 'upcoming_event_widget.dart';

class ComingWeekEventsWidget extends ConsumerWidget {
  const ComingWeekEventsWidget({super.key});

  final double cardHeight = 96;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final comingEvents = ref.watch(comingEventsProvider);

    return Column(
      children: [
        WidgetHeader(
          title: "Opkomende evenementen",
          onTapName: "Agenda",
          onTap: () => Routemaster.of(context).push('events'),
        ),
        InkWell(
          borderRadius: const BorderRadius.all(Radius.circular(16)),
          onTap: () => Routemaster.of(context).push('events'),
          child: SizedBox(
            height: cardHeight,
            child: comingEvents.when(
              data: (events) => FadeBottomWidget(
                parentHeight: cardHeight,
                child: ListView.builder(
                  itemCount: events.length,
                  itemBuilder: (context, index) {
                    Event event = events[index];
                    const double elementPadding = 4;

                    return UpcomingEventWidget(
                      elementPadding: elementPadding,
                      event: event,
                    ).paddingDirectional(horizontal: elementPadding);
                  },
                ),
              ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stackTrace) =>
                  ErrorCardWidget(errorMessage: error.toString()),
            ),
          ).card(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(16)),
            ),
          ),
        ),
      ],
    );
  }
}
