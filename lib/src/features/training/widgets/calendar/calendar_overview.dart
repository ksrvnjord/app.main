import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ksrvnjord_main_app/src/features/training/api/reservation_object_favorites_notifier.dart';
import 'package:ksrvnjord_main_app/src/features/training/api/reservation_object_type_filters_notifier.dart';
import 'package:ksrvnjord_main_app/src/features/training/widgets/calendar/widgets/time_scrollview.dart';
import 'package:ksrvnjord_main_app/src/features/training/widgets/calendar/widgets/vertical_reservation_scrollview_with_header.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:ksrvnjord_main_app/src/features/training/widgets/calendar/calendar_measurement.dart';

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
  final ScrollController boatsController = ScrollController(
      initialScrollOffset: CalendarMeasurement.initialPagePosition());
  final ScrollController timesController = ScrollController(
      initialScrollOffset: CalendarMeasurement.initialPagePosition());
  late DateTime currentTime;
  late final Timer currentTimeTimer;

  @override
  void initState() {
    currentTime = DateTime.now();
    currentTimeTimer = Timer.periodic(const Duration(minutes: 1), (_) {
      if (!mounted) {
        return;
      }

      setState(() {
        currentTime = DateTime.now();
      });
    });

    boatsController.addListener(() {
      if (boatsController.offset != timesController.offset) {
        timesController.jumpTo(boatsController.offset);
      }
    }); // This makes the time column scroll with the boats.

    super.initState();
  }

  @override
  void dispose() {
    currentTimeTimer.cancel();
    boatsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<String> filters = ref.watch(reservationTypeFiltersListProvider);
    final showFavorites = ref.watch(showFavoritesProvider);
    const double iconPadding = 8;

    return filters.isEmpty && !showFavorites
        ? <Widget>[
            const Icon(Icons.waves).padding(all: iconPadding),
            const Text(
              'Filter op een type om de beschikbaarheid te zien',
            ),
          ].toColumn(mainAxisAlignment: MainAxisAlignment.center)
        : Stack(
            children: <Widget>[
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: VerticalReservationScrollViewWithHeader(
                  boatsController: boatsController,
                  date: widget.date,
                  currentTime: currentTime,
                ),
              ), // This builds the columns with the boats and the slots.
              TimeScrollView(
                timesController: timesController,
              ), // This builds the time column on the left side.
            ],
          );
  }
}
