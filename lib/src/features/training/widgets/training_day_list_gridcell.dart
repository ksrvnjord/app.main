import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ksrvnjord_main_app/src/features/training/model/reservationObject.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:routemaster/routemaster.dart';

class TrainingDayListGridCell extends StatelessWidget {
  final QueryDocumentSnapshot<ReservationObject> boat;
  final List<DateTime> forbiddenSlots;
  final DateTime timestamp;
  final AsyncSnapshot<IdTokenResult> user;

  const TrainingDayListGridCell({
    Key? key,
    required this.boat,
    required this.forbiddenSlots,
    required this.timestamp,
    required this.user,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<dynamic> boatPermissions = boat.get('permissions');
    Map<String, dynamic> userClaims = user.data!.claims!;
    if (forbiddenSlots.contains(timestamp)) {
      return Container(color: Colors.grey);
    } else if (boatPermissions.isEmpty) {
      return TrainingDayListGridCellAllowed(boat: boat, timestamp: timestamp);
    } else if (boatPermissions
        .toSet()
        .intersection(userClaims['permissions'].toSet())
        .isNotEmpty) {
      return TrainingDayListGridCellAllowed(boat: boat, timestamp: timestamp);
    } else {
      return Container();
    }
  }
}

class TrainingDayListGridCellAllowed extends StatelessWidget {
  final QueryDocumentSnapshot<ReservationObject> boat;
  final DateTime timestamp;

  const TrainingDayListGridCellAllowed({
    Key? key,
    required this.boat,
    required this.timestamp,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var navigator = Routemaster.of(context);
    return IconButton(
        icon: const Icon(LucideIcons.plusCircle, size: 12, color: Colors.grey),
        onPressed: () {
          navigator.push('plan', queryParameters: {
            'reservationObjectId': boat.id,
            'reservationObjectName': boat.get('name'),
            'startTime': timestamp.toIso8601String(),
          });
        });
  }
}
