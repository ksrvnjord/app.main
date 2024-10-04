import 'package:autologin/autologin.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ksrvnjord_main_app/src/features/authentication/model/auth_controller.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/error_card_widget.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/rounded_elevated_button.dart';
import 'package:styled_widget/styled_widget.dart';

class LoginForm extends ConsumerStatefulWidget {
  const LoginForm({super.key});

  @override
  createState() => _LoginFormState();
}

class _LoginFormState extends ConsumerState<LoginForm> {
  final GlobalKey<FormState> _formKey = GlobalKey(debugLabel: 'LoginForm');

  final _email = TextEditingController();
  final _password = TextEditingController();

  // Initstate.
  @override
  void initState() {
    super.initState();
    try {
      AutologinPlugin.setup(
        domain: 'app.njord.nl',
        appId: "com.ksrvnjord.app",
        appName: "Njord",
      );
    } catch (error) {
      FirebaseCrashlytics.instance
          .recordError(error, StackTrace.current)
          .ignore();
    }

    // ignore: prefer-async-await, avoid-async-call-in-sync-function
    AutologinPlugin.requestCredentials().then((credentials) {
      if (credentials == null) return;
      _email.text = credentials.username ?? '';
      _password.text = credentials.password ?? '';
    }).onError((error, stackTrace) {
      FirebaseCrashlytics.instance.recordError(error, stackTrace).ignore();
    });
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final auth = ref.watch(authControllerProvider);

    const double errorTextPadding = 8;
    const double textFormFieldPadding = 8;

    const double buttonHeight = 54;
    const double buttonPaddding = 8;

    const double columnPadding = 16;
    const double cardPadding = 16;

    return <Widget>[
      auth.when(
        data: (data) => (data.error != '')
            ? Text(data.error, style: const TextStyle(color: Colors.red))
                .padding(all: errorTextPadding)
            : const SizedBox.shrink(),
        error: (e, _) => ErrorCardWidget(errorMessage: e.toString()),
        loading: () => const CircularProgressIndicator.adaptive(),
      ),
      Form(
        key: _formKey,
        child: <Widget>[
          TextFormField(
            controller: _email,
            decoration: const InputDecoration(
              icon: Icon(Icons.person),
              labelText: 'Email',
              hintText: "praeses@njord.nl",
              border: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.all(Radius.circular(40)),
              ),
            ),
            textCapitalization: TextCapitalization.none,
            obscureText: false,
            autocorrect: false,
            enableSuggestions: false,
          ).padding(all: textFormFieldPadding),
          TextFormField(
            controller: _password,
            decoration: const InputDecoration(
              icon: Icon(Icons.lock),
              labelText: 'Wachtwoord',
              hintText: "Trekeenbak@17:26",
              border: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.all(Radius.circular(40)),
              ),
            ),
            obscureText: true,
            autocorrect: false,
          ).padding(all: textFormFieldPadding),
        ].toColumn(mainAxisSize: MainAxisSize.min),
      ),
      <Widget>[
        RoundedElevatedButton(
          onPressed: () => ref
              .read(authControllerProvider.notifier)
              .login(_email.text, _password.text)
              .ignore(),
          child: const Text("Inloggen"),
        ).height(buttonHeight).padding(all: buttonPaddding).expanded(),
        RoundedElevatedButton(
          onPressed: () => context.goNamed('Forgot Password'),
          child: const Text("Vergeten"),
        ).height(buttonHeight).padding(all: buttonPaddding).expanded(),
      ].toRow(),
    ]
        .toColumn(mainAxisSize: MainAxisSize.min)
        .padding(all: columnPadding)
        .card(
          elevation: 0,
          shape: RoundedRectangleBorder(
            side: BorderSide(
              color: Theme.of(context).colorScheme.outline,
            ),
            borderRadius: const BorderRadius.all(Radius.circular(12)),
          ),
        )
        .padding(all: cardPadding)
        .alignment(Alignment.center);
  }
}
