import 'package:flutter/material.dart';
import 'package:ksrvnjord_main_app/assets/images.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/logo_widget.dart';
import 'package:routemaster/routemaster.dart';
import 'package:styled_widget/styled_widget.dart';

class _RegisterFormCard extends StatelessWidget {
  const _RegisterFormCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const double textPadding = 16;

    const double buttonHeight = 54;
    const double buttonPadding = 16;
    const double cardElevation = 8;
    const double cardOuterPadding = 16;
    const double cardInnerPadding = 24;
    const double textSize = 16;

    return [
      const Text(
        'Op dit moment kan een account alleen aangemaakt worden via de website',
        textAlign: TextAlign.center,
      ).fontSize(textSize).padding(vertical: textPadding),
      [
        ElevatedButton(
          child: const Text('Ga naar de website').fontSize(textSize),
          onPressed: () => Routemaster.of(context).push('/register/webview'),
        ).height(buttonHeight).padding(right: buttonPadding).expanded(),
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: Colors.blueGrey),
          child: const Icon(Icons.arrow_back),
          onPressed: () => Routemaster.of(context).pop(),
        ).height(buttonHeight),
      ].toRow(),
    ]
        .toColumn()
        .padding(all: cardInnerPadding)
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

// ignore: no-empty-block
void dontCall(bool _) {}

class RegisterPage extends StatelessWidget {
  final void Function(bool) loginCallback;

  const RegisterPage({Key? key, this.loginCallback = dontCall})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    const double logoPadding = 8;

    return Scaffold(
      appBar: null,
      backgroundColor: Colors.lightBlue,
      body: <Widget>[
        const LogoWidget(image: Images.appLogo).padding(bottom: logoPadding),
        const _RegisterFormCard(),
      ].toColumn(mainAxisAlignment: MainAxisAlignment.center),
    );
  }
}
