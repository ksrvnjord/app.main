import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:ksrvnjord_main_app/src/features/authentication/model/auth_model.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:ksrvnjord_main_app/assets/images.dart';
import 'package:ksrvnjord_main_app/src/features/authentication/presentation/login_form.dart';
import 'package:ksrvnjord_main_app/src/features/shared/presentation/logo_widget.dart';

class _LoginFormCard extends StatefulWidget {
  const _LoginFormCard({Key? key, required this.loginCallback})
      : super(key: key);
  final void Function(bool) loginCallback;

  @override
  _LoginFormCardState createState() => _LoginFormCardState();
}

class _LoginFormCardState extends State<_LoginFormCard> {
  var auth = GetIt.I.get<AuthModel>();

  @override
  Widget build(BuildContext context) {
    final router = AutoRouter.of(context);

    return AnimatedBuilder(
        animation: auth,
        builder: (_, __) {
          if (auth.isBusy) {
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

          if (auth.client != null) {
            return <Widget>[
              <Widget>[
                const Text('\uD83E\uDDA2', style: TextStyle(fontSize: 40))
              ].toRow(mainAxisAlignment: MainAxisAlignment.center),
              const Text('Je bent ingelogd.').padding(top: 20),
              <Widget>[
                ElevatedButton(
                  child: const Text('Doorgaan'),
                  onPressed: () {
                    router.pushNamed('/');
                  },
                )
              ].toRow(mainAxisAlignment: MainAxisAlignment.center),
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

          return LoginForm(loginCallback: widget.loginCallback);
        });
  }
}

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key, required this.loginCallback}) : super(key: key);
  final void Function(bool) loginCallback;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: null,
        backgroundColor: Colors.lightBlue,
        body: <Widget>[
          const LogoWidget(image: Images.appLogo).padding(bottom: 10),
          _LoginFormCard(
            loginCallback: loginCallback,
          )
        ].toColumn(mainAxisAlignment: MainAxisAlignment.center));
  }
}
