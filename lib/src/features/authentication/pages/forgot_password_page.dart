import 'package:flutter/material.dart';
import 'package:ksrvnjord_main_app/assets/images.dart';
import 'package:ksrvnjord_main_app/src/features/authentication/widgets/form_card.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/logo_widget.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:url_launcher/url_launcher.dart';

class ForgotPasswordPage extends StatelessWidget {
  final void Function(bool) loginCallback;

  const ForgotPasswordPage({Key? key, this.loginCallback = dontCall})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    const double logoPadding = 8;

    return Scaffold(
      appBar: null,
      body: <Widget>[
        const LogoWidget(image: Images.appLogo).padding(bottom: logoPadding),
        FormCard(
          explanation:
              'Op dit moment kan een wachtwoord alleen gereset worden via de website',
          buttonText: 'Ga naar de website',
          onPressed: () => launchUrl(
            Uri.parse('https://heimdall.njord.nl/forgot-password'),
          ),
        ),
      ].toColumn(mainAxisAlignment: MainAxisAlignment.center),
      backgroundColor: Colors.lightBlue,
    );
  }
}

// ignore: no-empty-block
void dontCall(bool _) {}
