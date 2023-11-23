import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ksrvnjord_main_app/assets/images.dart';
import 'package:ksrvnjord_main_app/src/features/authentication/model/auth_model.dart';
import 'package:ksrvnjord_main_app/src/features/authentication/model/auth_state.dart';
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

    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: null,
      body: <Widget>[
        const LogoWidget(image: Images.appLogo).padding(bottom: logoPadding),
        auth.authState ==
                AuthState
                    .loading // Wait for try login into Firebase and Heimdall.
            ? const LoginLoadingWidget()
            : const LoginForm(),
        DottedBorder(
          color: Colors.blueGrey,
          strokeWidth: 4,
          borderType: BorderType.RRect,
          radius: const Radius.circular(16),
          strokeCap: StrokeCap.square,
          dashPattern: [8, 8],
          child: Text(
            "Uw logo hier",
            style: textTheme.displayLarge?.copyWith(
              color: Colors.blueGrey,
              fontWeight: FontWeight.bold,
            ),
          ).padding(all: 16, top: 32, bottom: 32),
        ),
      ].toColumn(mainAxisAlignment: MainAxisAlignment.center),
    );
  }
}
