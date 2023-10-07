import 'package:flutter/material.dart';
import 'package:styled_widget/styled_widget.dart';

class LoginLoadingWidget extends StatelessWidget {
  const LoginLoadingWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const double textPadding = 16;
    const double columnPadding = 16;
    const double cardElevation = 8;
    const double cardPadding = 16;

    return <Widget>[
      <Widget>[
        const CircularProgressIndicator.adaptive(
          semanticsLabel: 'Trying to log in',
        ),
      ].toRow(mainAxisAlignment: MainAxisAlignment.center),
      const Text('Zwanen aan het voeren...').padding(top: textPadding),
    ]
        .toColumn(mainAxisSize: MainAxisSize.min)
        .padding(all: columnPadding)
        .card(
          elevation: cardElevation,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
        )
        .padding(all: cardPadding)
        .alignment(Alignment.center);
  }
}
