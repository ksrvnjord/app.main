import 'package:flutter/material.dart';
import 'package:ksrvnjord_main_app/src/features/authentication/widgets/form_card.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:url_launcher/url_launcher.dart';

class ForgotPasswordPage extends StatelessWidget {
  const ForgotPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      body: <Widget>[
        FormCard(
          explanation:
              'Op dit moment kan een wachtwoord alleen gereset worden via de website',
          buttonText: 'Ga naar de website',
          onPressed: () => launchUrl(
            Uri.parse('https://heimdall.njord.nl/forgot-password'),
          ),
        ),
      ].toColumn(mainAxisAlignment: MainAxisAlignment.center),
    );
  }
}
