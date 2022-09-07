import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:styled_widget/styled_widget.dart';

class LoginDoneWidget extends StatelessWidget {
  const LoginDoneWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final router = AutoRouter.of(context);

    return <Widget>[
      <Widget>[const Text('\uD83E\uDDA2', style: TextStyle(fontSize: 40))]
          .toRow(mainAxisAlignment: MainAxisAlignment.center),
      const Text('Je bent ingelogd.').padding(top: 20),
      <Widget>[
        ElevatedButton(
          child: const Text('Doorgaan'),
          onPressed: () {
            router.replaceNamed('/');
          },
        )
      ].toRow(mainAxisAlignment: MainAxisAlignment.center),
    ]
        .toColumn(mainAxisSize: MainAxisSize.min)
        .padding(all: 20)
        .card(
          elevation: 10,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        )
        .padding(all: 12)
        .alignment(Alignment.center);
  }
}
