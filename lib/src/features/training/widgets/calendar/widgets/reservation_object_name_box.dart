import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/future_wrapper.dart';
import 'package:ksrvnjord_main_app/src/features/training/model/reservation_object.dart';
import 'package:ksrvnjord_main_app/src/features/training/widgets/calendar/calendar_measurement.dart';
import 'package:routemaster/routemaster.dart';
import 'package:styled_widget/styled_widget.dart';

class ReservationObjectNameBox extends StatelessWidget {
  const ReservationObjectNameBox({
    super.key,
    required this.reservationObj,
  });

  final QueryDocumentSnapshot<ReservationObject> reservationObj;

  @override
  Widget build(BuildContext context) {
    ReservationObject reservationObject = reservationObj.data();

    const double boatButtonWidth = CalendarMeasurement.slotWidth;
    const double boatButtonHeight = 64;

    Future<bool> boatPermitted() async {
      final token = await FirebaseAuth.instance.currentUser?.getIdTokenResult();

      if (token != null) {
        if (reservationObject.permissions.isEmpty ||
            reservationObject.permissions
                .toSet()
                .intersection((token.claims?['permissions'] ?? []).toSet())
                .isNotEmpty) {
          return true;
        }
      }

      return false;
    }

    final colorScheme = Theme.of(context).colorScheme;
    const double textHPadding = 8;
    const notAvailableBackgroundOpacity = 0.5;
    const textOpacity = 0.8;

    return FutureWrapper(
      future: boatPermitted(),
      success: (bool isAvailable) => SizedBox(
        width: boatButtonWidth,
        height: boatButtonHeight,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
          child: InkWell(
            child: Card(
              color: reservationObject.critical
                  ? Theme.of(context).colorScheme.errorContainer
                  : isAvailable
                      ? colorScheme.secondaryContainer
                      : colorScheme.surface
                          .withOpacity(notAvailableBackgroundOpacity),
              margin: EdgeInsets.zero,
              child: Text(
                reservationObject.name,
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: reservationObject.critical
                          ? colorScheme.onErrorContainer
                              .withOpacity(textOpacity)
                          : isAvailable
                              ? colorScheme.onSecondaryContainer
                              : colorScheme.onSurface.withOpacity(textOpacity),
                    ),
              ).center().padding(horizontal: textHPadding),
            ),
            onTap: () => Routemaster.of(context).push(
              'reservationObject/${reservationObj.id}',
              queryParameters: {'name': reservationObject.name},
            ),
          ),
        ),
      ),
    );
  }
}
