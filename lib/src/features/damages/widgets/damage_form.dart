import 'package:flutter/material.dart';
import 'package:ksrvnjord_main_app/src/features/damages/model/damage.dart';

class DamageForm extends StatefulWidget {
  final Damage damage;

  const DamageForm({Key? key, required this.damage}) : super(key: key);

  @override
  State<DamageForm> createState() => _DamageFormState();
}

class _DamageFormState extends State<DamageForm> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
