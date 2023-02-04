import 'package:flutter/material.dart';
import 'package:styled_widget/styled_widget.dart';

class LoginLoadingWidget extends StatelessWidget {
  const LoginLoadingWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return <Widget>[
      <Widget>[
        const CircularProgressIndicator(
          semanticsLabel: 'Trying to log in',
        ),
      ].toRow(mainAxisAlignment: MainAxisAlignment.center),
      const Text('Zwanen aan het voeren...').padding(top: 20),
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
