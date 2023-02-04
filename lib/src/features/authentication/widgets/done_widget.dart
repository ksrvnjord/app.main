import 'package:flutter/material.dart';
import 'package:routemaster/routemaster.dart';
import 'package:styled_widget/styled_widget.dart';

class LoginDoneWidget extends StatelessWidget {
  const LoginDoneWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // ignore: avoid-non-ascii-symbols
    const String swanEmoji = "\uD83E\uDDA2";

    return <Widget>[
      <Widget>[const Text(swanEmoji, style: TextStyle(fontSize: 40))]
          .toRow(mainAxisAlignment: MainAxisAlignment.center),
      const Text('Je bent ingelogd.').padding(top: 20),
      <Widget>[
        ElevatedButton(
          child: const Text('Doorgaan'),
          onPressed: () {
            Routemaster.of(context).push('/');
          },
        ),
      ].toRow(mainAxisAlignment: MainAxisAlignment.center),
    ]
        .toColumn(mainAxisSize: MainAxisSize.min)
        .padding(all: 20)
        .card(
          elevation: 10,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
        )
        .padding(all: 12)
        .alignment(Alignment.center);
  }
}
