import 'package:flutter/material.dart';
import 'package:ksrvnjord_main_app/assets/images.dart';
import 'package:ksrvnjord_main_app/src/features/authentication/widgets/form_card.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/logo_widget.dart';
import 'package:routemaster/routemaster.dart';
import 'package:styled_widget/styled_widget.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const double logoPadding = 8;

    return Scaffold(
      appBar: null,
      backgroundColor: Colors.lightBlue,
      body: <Widget>[
        const LogoWidget(image: Images.appLogo).padding(bottom: logoPadding),
        FormCard(
          explanation:
              'Op dit moment kan een account alleen aangemaakt worden via de website',
          buttonText: 'Ga naar de website',
          onPressed: () => Routemaster.of(context).push('/register/webview'),
        ),
      ].toColumn(mainAxisAlignment: MainAxisAlignment.center),
    );
  }
}
