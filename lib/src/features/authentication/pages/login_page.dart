import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:ksrvnjord_main_app/assets/images.dart';
import 'package:ksrvnjord_main_app/src/features/authentication/model/auth_model.dart';
import 'package:ksrvnjord_main_app/src/features/authentication/widgets/done_widget.dart';
import 'package:ksrvnjord_main_app/src/features/authentication/widgets/loading_widget.dart';
import 'package:ksrvnjord_main_app/src/features/authentication/widgets/login_form.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/logo_widget.dart';
import 'package:styled_widget/styled_widget.dart';

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
    return AnimatedBuilder(
        animation: auth,
        builder: (_, __) {
          if (auth.isBusy) {
            return const LoginLoadingWidget();
          }

          if (auth.client != null) {
            return const LoginDoneWidget();
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
