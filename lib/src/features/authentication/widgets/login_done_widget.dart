import 'package:flutter/material.dart';
import 'package:routemaster/routemaster.dart';
import 'package:styled_widget/styled_widget.dart';

class LoginDoneWidget extends StatelessWidget {
  const LoginDoneWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // ignore: avoid-non-ascii-symbols
    const String swanEmoji = "\uD83E\uDDA2";

    const double textPadding = 16;
    const double columnPadding = 16;
    const double cardElevation = 8;
    const double cardOuterPadding = 16;

    return <Widget>[
      <Widget>[const Text(swanEmoji, style: TextStyle(fontSize: 40))]
          .toRow(mainAxisAlignment: MainAxisAlignment.center),
      const Text('Je bent ingelogd.').padding(top: textPadding),
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
        .padding(all: columnPadding)
        .card(
          elevation: cardElevation,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
        )
        .padding(all: cardOuterPadding)
        .alignment(Alignment.center);
  }
}
