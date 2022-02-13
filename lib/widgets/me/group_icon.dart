import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:ksrvnjord_main_app/widgets/me/delete_group_dialog.dart';
import 'package:ksrvnjord_main_app/widgets/me/add_group_dialog.dart';
import 'package:ksrvnjord_main_app/widgets/me/verification_dialog.dart';

class GroupIcon extends StatelessWidget {
  const GroupIcon(this.label, this.values, this.isDelete, {Key? key})
      : super(key: key);

  final String label;
  final List<String> values;
  final bool isDelete;

  @override
  Widget build(BuildContext context) {
    return IconButton(
        padding: const EdgeInsets.all(0),
        constraints: const BoxConstraints(),
        iconSize: (isDelete) ? 25 : 30,
        icon: Icon((isDelete) ? Icons.delete : Icons.add,
            color: (isDelete) ? Colors.grey : Colors.green),
        onPressed: () async {
          bool succesful_change = await showDialog(
              context: context,
              builder: (BuildContext context) => (isDelete)
                  ? DeleteGroupDialog(label: label, values: values)
                  : AddGroupDialog(label: label, values: values));
          if (succesful_change == true) {
            const String title = '''Gegevensverandering was succesvol!\n\n''';
            const String body =
                '''Aangezien elke verandering door het bestuur moet worden goedgekeurd, kan het even duren voordat de verandering daadwerkelijk zichtbaar is.''';
            showDialog(
                barrierDismissible: false,
                barrierColor: null,
                context: context,
                builder: (BuildContext context) =>
                    const VerificationDialog(title, body));
          }
        });
  }
}
