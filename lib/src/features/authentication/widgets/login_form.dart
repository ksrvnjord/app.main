import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ksrvnjord_main_app/src/features/authentication/model/auth_model.dart';
import 'package:ksrvnjord_main_app/src/features/shared/model/graphql_model.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/rounded_elevated_button.dart';
import 'package:styled_widget/styled_widget.dart';

class LoginForm extends ConsumerStatefulWidget {
  static const routename = '/login';
  const LoginForm({Key? key}) : super(key: key);

  @override
  createState() => _LoginFormState();
}

class _LoginFormState extends ConsumerState<LoginForm> {
  final GlobalKey<FormState> _formKey = GlobalKey(debugLabel: 'LoginForm');

  final _username = TextEditingController();
  final _password = TextEditingController();

  void login(AuthModel auth, GraphQLModel _) async {
    // ignore: avoid-ignoring-return-values
    await auth.login(_username.text, _password.text);
    // ignore: avoid-ignoring-return-values
    await auth.firebase();
  }

  @override
  Widget build(BuildContext context) {
    final auth = ref.watch(authModelProvider);
    final graphql = ref.watch(graphQLModelProvider);

    const double errorTextPadding = 8;
    const double textFormFieldPadding = 8;

    const double buttonHeight = 54;
    const double buttonPaddding = 8;

    const double columnPadding = 16;
    const double cardPadding = 16;

    return <Widget>[
      AnimatedBuilder(
        animation: auth,
        builder: (_, __) {
          if (auth.error != '') {
            return Text(auth.error, style: const TextStyle(color: Colors.red))
                .padding(all: errorTextPadding);
          }

          return Container();
        },
      ),
      Form(
        key: _formKey,
        child: <Widget>[
          TextFormField(
            controller: _username,
            decoration: const InputDecoration(
              icon: Icon(Icons.person),
              labelText: 'Njord-account',
              hintText: "james.cohen.stuart",
              border: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.all(Radius.circular(40)),
              ),
            ),
            textCapitalization: TextCapitalization.none,
            obscureText: false,
            autocorrect: false,
            enableSuggestions: false,
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.allow(RegExp('[a-z\\.]')),
            ],
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
          onPressed: () => login(auth, graphql),
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
