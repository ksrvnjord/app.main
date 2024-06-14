import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ksrvnjord_main_app/assets/images.dart';
import 'package:ksrvnjord_main_app/src/features/authentication/model/auth_controller.dart';
import 'package:ksrvnjord_main_app/src/features/authentication/widgets/login_loading_widget.dart';
import 'package:ksrvnjord_main_app/src/features/authentication/widgets/login_form.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/error_card_widget.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/logo_widget.dart';
import 'package:styled_widget/styled_widget.dart';

class LoginPage extends ConsumerWidget {
  const LoginPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const double logoPadding = 8;
    final auth = ref.watch(authControllerProvider);

    return Scaffold(
      appBar: null,
      body: <Widget>[
        const LogoWidget(image: Images.appLogoBlue)
            .padding(bottom: logoPadding),
        auth.when(
          data: (_) => const LoginForm(),
          loading: () => const LoginLoadingWidget(),
          error: (e, _) => ErrorCardWidget(errorMessage: e.toString()),
        ),
        // Textbutton to navigate to the privacy policy page.
        TextButton(
          onPressed: () => unawaited(context.pushNamed("Privacy Beleid")),
          child: const Text('Bekijk het Privacy Beleid van deze app'),
        ),
      ].toColumn(mainAxisAlignment: MainAxisAlignment.center),
    );
  }
}
