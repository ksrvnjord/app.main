import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ksrvnjord_main_app/assets/images.dart';
import 'package:ksrvnjord_main_app/src/features/authentication/model/auth_model.dart';
import 'package:ksrvnjord_main_app/src/features/authentication/widgets/login_done_widget.dart';
import 'package:ksrvnjord_main_app/src/features/authentication/widgets/login_loading_widget.dart';
import 'package:ksrvnjord_main_app/src/features/authentication/widgets/login_form.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/logo_widget.dart';
import 'package:styled_widget/styled_widget.dart';

class LoginPage extends ConsumerWidget {
  const LoginPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const double logoPadding = 8;
    final auth = ref.watch(authModelProvider);

    return Scaffold(
      appBar: null,
      body: <Widget>[
        const LogoWidget(image: Images.appLogo).padding(bottom: logoPadding),
        auth.isBusy
            ? const LoginLoadingWidget()
            : auth.client != null
                ? const LoginDoneWidget()
                : const LoginForm(),
      ].toColumn(mainAxisAlignment: MainAxisAlignment.center),
      backgroundColor: Colors.lightBlue,
    );
  }
}
