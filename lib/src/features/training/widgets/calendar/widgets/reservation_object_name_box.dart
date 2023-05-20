import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/future_wrapper.dart';
import 'package:ksrvnjord_main_app/src/features/training/model/reservation_object.dart';
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

    const double boatButtonWidth = 128;
    const double boatButtonHeight = 64;
    const double boatButtonElevation = 4;

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

    return FutureWrapper(
      future: boatPermitted(),
      success: (isAvailable) => SizedBox(
        width: boatButtonWidth,
        height: boatButtonHeight,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
          child: Stack(
            fit: StackFit.expand,
            children: [
              TextButton(
                onPressed: () => Routemaster.of(context).push(
                  'reservationObject/${reservationObj.id}',
                  queryParameters: {'name': reservationObject.name},
                ),
                style: TextButton.styleFrom(
                  alignment: Alignment.center,
                  backgroundColor: reservationObject.critical
                      ? Colors.orange[100]
                      : isAvailable
                          ? Colors.white
                          : Colors.grey[100],
                  elevation: boatButtonElevation,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(16)),
                  ),
                ),
                child: Text(reservationObj.data().name).textStyle(TextStyle(
                  color: reservationObject.critical
                      ? Colors.orange[900]
                      : isAvailable
                          ? Colors.black
                          : Colors.grey[600],
                )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
