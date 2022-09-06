import 'package:flutter/material.dart';
import 'package:ksrvnjord_main_app/src/features/authentication/model/auth_model.dart';
import 'package:provider/provider.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:ksrvnjord_main_app/assets/images.dart';
import 'package:ksrvnjord_main_app/src/features/authentication/presentation/login_form.dart';
import 'package:ksrvnjord_main_app/src/features/shared/presentation/logo_widget.dart';

class _LoginFormCard extends StatelessWidget {
  const _LoginFormCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthModel>(builder: ((context, value, child) {
      if (value.isBusy) {
        return <Widget>[
          <Widget>[
            const CircularProgressIndicator(
              semanticsLabel: 'Trying to log in',
            )
          ].toRow(mainAxisAlignment: MainAxisAlignment.center),
          const Text('Zwanen aan het voeren...').padding(top: 20)
        ]
            .toColumn(mainAxisSize: MainAxisSize.min)
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

      return const LoginForm();
    }));
  }
}

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: null,
        backgroundColor: Colors.blueAccent,
        body: <Widget>[
          const LogoWidget(image: Images.appLogo).padding(bottom: 10),
          const _LoginFormCard()
        ].toColumn(mainAxisAlignment: MainAxisAlignment.center));
  }
}
