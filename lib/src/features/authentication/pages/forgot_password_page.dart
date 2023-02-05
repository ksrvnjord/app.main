import 'package:flutter/material.dart';
import 'package:ksrvnjord_main_app/assets/images.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/logo_widget.dart';
import 'package:routemaster/routemaster.dart';
import 'package:styled_widget/styled_widget.dart';

class _ForgotFormCard extends StatelessWidget {
  const _ForgotFormCard({Key? key, required this.loginCallback})
      : super(key: key);
  final void Function(bool) loginCallback;

  @override
  Widget build(BuildContext context) {
    // TODO: Implement in Heimdall
    // return const ForgotForm();
    const double textPadding = 16;

    const double buttonHeight = 54;
    const double buttonPadding = 16;
    const double cardElevation = 8;
    const double cardOuterPadding = 16;
    const double cardInnerPadding = 24;
    const double textSize = 16;

    return [
      const Text(
        'Op dit moment kan een wachtwoord alleen gereset worden via de website',
        textAlign: TextAlign.center,
      ).fontSize(textSize).padding(vertical: textPadding),
      [
        ElevatedButton(
          child: const Text('Ga naar de website').fontSize(textSize),
          onPressed: () => Routemaster.of(context).push('/forgot/webview'),
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

class ForgotPasswordPage extends StatelessWidget {
  final void Function(bool) loginCallback;

  const ForgotPasswordPage({Key? key, this.loginCallback = dontCall})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    const double logoPadding = 8;

    return Scaffold(
      appBar: null,
      backgroundColor: Colors.lightBlue,
      body: <Widget>[
        const LogoWidget(image: Images.appLogo).padding(bottom: logoPadding),
        _ForgotFormCard(
          loginCallback: loginCallback,
        ),
      ].toColumn(mainAxisAlignment: MainAxisAlignment.center),
    );
  }
}
