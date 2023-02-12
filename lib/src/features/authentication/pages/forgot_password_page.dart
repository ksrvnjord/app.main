import 'package:flutter/material.dart';
import 'package:ksrvnjord_main_app/assets/images.dart';
import 'package:ksrvnjord_main_app/src/features/authentication/widgets/forgot_form_card.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/logo_widget.dart';
import 'package:styled_widget/styled_widget.dart';

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
        ForgotFormCard(
          loginCallback: loginCallback,
        ),
      ].toColumn(mainAxisAlignment: MainAxisAlignment.center),
    );
  }
}

// ignore: no-empty-block
void dontCall(bool _) {}
