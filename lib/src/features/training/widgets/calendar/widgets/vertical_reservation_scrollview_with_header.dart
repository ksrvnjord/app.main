import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ksrvnjord_main_app/src/features/training/widgets/calendar/filters/api/reservation_objects.dart';
import 'package:ksrvnjord_main_app/src/features/training/widgets/calendar/object_calendar.dart';
import 'package:ksrvnjord_main_app/src/features/training/widgets/calendar/widgets/reservation_object_name_box.dart';
import 'package:sticky_headers/sticky_headers.dart';
import 'package:styled_widget/styled_widget.dart';

class VerticalReservationScrollViewWithHeader extends ConsumerWidget {
  const VerticalReservationScrollViewWithHeader({
    super.key,
    required this.boatsController,
    required this.date,
  });

  final ScrollController boatsController;
  final DateTime date;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final availableReservationObjects =
        ref.watch(sortedAvailableReservationObjectProvider);

    const double verticalLineWidth = 0.2;

    return availableReservationObjects.when(
      data: (data) => SingleChildScrollView(
        scrollDirection: Axis.vertical,
        controller: boatsController,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 64),
          child: StickyHeader(
            header: data // This builds the header with the boat names.
                .map<Widget>(
                  (doc) => ReservationObjectNameBox(reservationObj: doc),
                )
                .toList()
                .toRow(),
            content: Stack(
              children: [
                data // This builds the content with the slots.
                    .map<Widget>((e) {
                      return ObjectCalendar(date: date, boat: e).border(
                        left: verticalLineWidth,
                        color: Theme.of(context).colorScheme.outline,
                      );
                    })
                    .toList()
                    .toRow(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                    ),
              ],
            ),
          ),
        ),
      ),
      loading: () => const Center(child: CircularProgressIndicator.adaptive()),
      error: (error, stack) => Text(error.toString()).card(),
    );
  }
}
