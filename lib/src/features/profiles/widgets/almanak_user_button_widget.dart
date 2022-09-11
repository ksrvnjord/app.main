import 'package:flutter/material.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/api/almanak.graphql.dart';
import 'package:styled_widget/styled_widget.dart';

class AlmanakUserButtonWidget extends StatelessWidget {
  final Query$Almanak$users$data user;

  const AlmanakUserButtonWidget(this.user, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return <Widget>[
      <Widget>[
        Text(user.fullContact.public.last_name ?? user.username),
        const Text(', '),
        Text(user.fullContact.public.first_name ?? ''),
      ]
          .toRow(mainAxisAlignment: MainAxisAlignment.start)
          .padding(all: 15)
          .card(elevation: 1)
    ].toColumn().padding(horizontal: 5, vertical: 1);
  }
}
