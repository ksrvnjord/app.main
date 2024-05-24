import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ksrvnjord_main_app/src/features/training/api/reservation_object_type_filters_notifier.dart';
import 'package:ksrvnjord_main_app/src/features/training/widgets/calendar/widgets/time_scrollview.dart';
import 'package:ksrvnjord_main_app/src/features/training/widgets/calendar/widgets/vertical_reservation_scrollview_with_header.dart';
import 'package:styled_widget/styled_widget.dart';

// Shows all available objects for a given day and filters.
class CalendarOverview extends ConsumerStatefulWidget {
  const CalendarOverview({
    super.key,
    required this.date,
  });

  final DateTime date;

  @override
  createState() => _CalendarOverview();
}

class _CalendarOverview extends ConsumerState<CalendarOverview> {
  final ScrollController boatsController = ScrollController();
  final ScrollController timesController = ScrollController();

  @override
  void initState() {
    boatsController.addListener(() {
      if (boatsController.offset != timesController.offset) {
        timesController.jumpTo(boatsController.offset);
      }
    }); // This makes the time column scroll with the boats.

    super.initState();
  }

  @override
  void dispose() {
    boatsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<String> filters = ref.watch(reservationTypeFiltersListProvider);
    const double iconPadding = 8;

    return filters.isEmpty
        ? <Widget>[
            const Icon(Icons.waves).padding(all: iconPadding),
            const Text(
              'Filter op een type om de beschikbaarheid te zien',
            ),
          ].toColumn(mainAxisAlignment: MainAxisAlignment.center)
        : Stack(
            children: <Widget>[
              SingleChildScrollView(
                key: UniqueKey(),
                scrollDirection: Axis.horizontal,
                child: VerticalReservationScrollViewWithHeader(
                  boatsController: boatsController,
                  date: widget.date,
                ),
              ), // This builds the columns with the boats and the slots.
              TimeScrollView(
                timesController: timesController,
              ), // This builds the time column on the left side.
            ],
          );
  }
}
