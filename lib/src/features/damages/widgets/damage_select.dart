import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/future_wrapper.dart';
import 'package:ksrvnjord_main_app/src/features/training/model/reservation_object.dart';
import 'package:ksrvnjord_main_app/src/features/damages/queries/all_object_types.dart';
import 'package:styled_widget/styled_widget.dart';

class DamageSelect extends StatefulWidget {
  final ReservationObject? object;

  const DamageSelect({Key? key, this.object}) : super(key: key);

  @override
  State<DamageSelect> createState() => _DamageSelectState();
}

class _DamageSelectState extends State<DamageSelect> {
  @override
  Widget build(BuildContext context) {
    return FutureWrapper(
      future: reservationObjectsByType(),
      success: (data) => <Widget>[
        DropdownButtonFormField(
          items: data.keys
              .toSet()
              .toList()
              .map<DropdownMenuItem>(
                (key) => DropdownMenuItem(
                  value: key,
                  child: Text(key),
                ),
              )
              .toList(),
          onChanged: (e) {},
        ),
      ].toColumn(),
    );
  }
}
