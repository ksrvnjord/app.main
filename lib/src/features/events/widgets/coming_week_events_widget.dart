import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ksrvnjord_main_app/src/features/dashboard/widgets/widget_header.dart';
import 'package:ksrvnjord_main_app/src/features/events/api/events_provider.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/error_card_widget.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/shimmer_widget.dart';
import 'package:styled_widget/styled_widget.dart';
import 'upcoming_event_widget.dart';

class ComingWeekEventsWidget extends ConsumerWidget {
  const ComingWeekEventsWidget({super.key});

  final double cardHeight = 96;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final comingEvents = ref.watch(comingEventsProvider);
    const amountOfEvents = 3;
    const double hPadding = 12;

    return Column(
      children: [
        WidgetHeader(
          title: "Evenementen",
          titleIcon: Icons.event,
          onTapName: "Volledige agenda",
          onTap: () => context.goNamed('Events'),
        ),
        InkWell(
          // ignore: sort_child_properties_last
          child: comingEvents.when(
            data: (snapshot) => [
              for (final doc in snapshot.docs.take(amountOfEvents))
                UpcomingEventWidget(
                  doc: doc,
                ),
            ].toColumn().padding(horizontal: hPadding),
            loading: () => ShimmerWidget(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: const BorderRadius.all(Radius.circular(12)),
                ),
                height: cardHeight,
              ),
            ).padding(horizontal: hPadding),
            error: (error, stackTrace) =>
                ErrorCardWidget(errorMessage: error.toString()),
          ),
          onTap: () => context.goNamed('Events'),
        ),
      ],
    );
  }
}
