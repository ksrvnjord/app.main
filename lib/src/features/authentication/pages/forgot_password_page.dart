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

    return [
      const Text(
        'Op dit moment kan een wachtwoord alleen gereset worden via de website',
        textAlign: TextAlign.center,
      ).padding(all: 10),
      [
        ElevatedButton(
                child: const Text('Ga naar de website'),
                onPressed: () =>
                    Routemaster.of(context).push('/forgot/webview'))
            .height(54)
            .padding(all: 10)
            .expanded(),
        ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.blueGrey),
            child: const Icon(Icons.arrow_back),
            onPressed: () =>
                Routemaster.of(context).pop()).height(54).padding(all: 10)
      ].toRow()
    ]
        .toColumn()
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

void dontCall(bool arg) {}

class ForgotPage extends StatelessWidget {
  final void Function(bool) loginCallback;

  const ForgotPage({Key? key, this.loginCallback = dontCall}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: null,
        backgroundColor: Colors.lightBlue,
        body: <Widget>[
          const LogoWidget(image: Images.appLogo).padding(bottom: 10),
          _ForgotFormCard(
            loginCallback: loginCallback,
          )
        ].toColumn(mainAxisAlignment: MainAxisAlignment.center));
  }
}
