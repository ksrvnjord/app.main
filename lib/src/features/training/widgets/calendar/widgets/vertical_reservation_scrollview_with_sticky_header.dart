import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/error_card_widget.dart';
import 'package:ksrvnjord_main_app/src/features/training/widgets/calendar/filters/api/reservation_objects.dart';
import 'package:ksrvnjord_main_app/src/features/training/widgets/calendar/object_calendar.dart';
import 'package:ksrvnjord_main_app/src/features/training/widgets/calendar/widgets/reservation_object_name_box.dart';
import 'package:sticky_headers/sticky_headers.dart';
import 'package:styled_widget/styled_widget.dart';

class VerticalReservationScrollViewWithStickyHeader extends ConsumerWidget {
  const VerticalReservationScrollViewWithStickyHeader({
    super.key,
    required this.boatsController,
    required this.date,
  });

  final ScrollController boatsController;
  final DateTime date;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final availableReservationObjects =
        ref.watch(availableReservationObjectsProvider);

    return availableReservationObjects.when(
      data: (data) => SingleChildScrollView(
        scrollDirection: Axis.vertical,
        controller: boatsController,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 64),
          child: StickyHeader(
            header: data.docs // this builds the header with the boat names
                .map<Widget>(
                  (doc) => ReservationObjectNameBox(reservationObj: doc),
                )
                .toList()
                .toRow(),
            content: data.docs // this builds the content with the slots
                .map<Widget>((e) {
                  return ObjectCalendar(date: date, boat: e).border(
                    left: 1,
                    color: const Color.fromARGB(255, 223, 223, 223),
                  );
                })
                .toList()
                .toRow(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                ),
          ),
        ),
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => ErrorCardWidget(errorMessage: error.toString()),
    );
  }
}
