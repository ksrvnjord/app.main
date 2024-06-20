import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/future_wrapper.dart';
import 'package:ksrvnjord_main_app/src/features/training/api/reservation_object_favorites_notifier.dart';
import 'package:ksrvnjord_main_app/src/features/training/model/reservation_object.dart';
import 'package:ksrvnjord_main_app/src/features/training/widgets/calendar/calendar_measurement.dart';
import 'package:styled_widget/styled_widget.dart';

class ReservationObjectNameBox extends ConsumerWidget {
  const ReservationObjectNameBox({
    super.key,
    required this.reservationObj,
  });

  final QueryDocumentSnapshot<ReservationObject> reservationObj;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ReservationObject reservationObject = reservationObj.data();

    const double boatButtonWidth = CalendarMeasurement.slotWidth;
    const double boatButtonHeight = 64;
    final favorites = ref.watch(favoriteObjectsProvider);

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
    const textOpacity = 0.8;
    const double sizeHeartIcon = 22;

    return FutureWrapper(
      future: boatPermitted(),
      success: (bool isAvailable) => Stack(
        alignment: AlignmentDirectional.topEnd,
        children: [
          SizedBox(
            width: boatButtonWidth,
            height: boatButtonHeight,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
              child: InkWell(
                child: Card(
                  color: reservationObject.critical
                      ? Theme.of(context).colorScheme.errorContainer
                      : isAvailable
                          ? colorScheme.primaryContainer
                          : colorScheme.surface,
                  margin: EdgeInsets.zero,
                  child: Text(
                    reservationObject.name,
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          color: reservationObject.critical
                              ? colorScheme.onErrorContainer
                                  .withOpacity(textOpacity)
                              : isAvailable
                                  ? colorScheme.onPrimaryContainer
                                  : colorScheme.onSurface
                                      .withOpacity(textOpacity),
                        ),
                  ).center().padding(horizontal: textHPadding),
                ),
                onTap: () => context.pushNamed(
                  'Show Reservation Object',
                  pathParameters: {'id': reservationObj.id},
                  queryParameters: {'name': reservationObject.name},
                ).ignore(),
              ),
            ),
          ),
          favorites.contains(reservationObject.name)
              ? Icon(
                  Icons.favorite_rounded,
                  size: sizeHeartIcon,
                  color: Theme.of(context).colorScheme.error,
                )
              : const Icon(Icons.favorite_border, size: 22),
        ],
      ),
    );
  }
}
