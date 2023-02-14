import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ksrvnjord_main_app/src/features/authentication/model/auth_model.dart';
import 'package:ksrvnjord_main_app/src/features/shared/model/graphql_model.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/rounded_elevated_button.dart';
import 'package:provider/provider.dart';
import 'package:routemaster/routemaster.dart';
import 'package:styled_widget/styled_widget.dart';

class LoginForm extends StatefulWidget {
  static const routename = '/login';
  const LoginForm({Key? key, required this.loginCallback}) : super(key: key);
  final void Function(bool) loginCallback;

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final GlobalKey<FormState> _formKey = GlobalKey(debugLabel: 'LoginForm');

  final _username = TextEditingController();
  final _password = TextEditingController();

  void login(AuthModel auth, GraphQLModel _) {
    auth.login(_username.text, _password.text).then((result) {
      // Also login to firebase.
      auth.firebase().then((_) => widget.loginCallback(result));
    });
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthModel>(context);
    final graphql = Provider.of<GraphQLModel>(context);

    const double errorTextPadding = 8;
    const double textFormFieldPadding = 8;

    const double buttonHeight = 54;
    const double buttonPaddding = 8;

    const double columnPadding = 16;
    const double cardPadding = 16;
    const double cardElevation = 8;

    const double registerTextHPadding = 4;

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
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.allow(RegExp('[a-z\\.]')),
            ],
            obscureText: false,
            autocorrect: false,
            enableSuggestions: false,
            textCapitalization: TextCapitalization.none,
            decoration: const InputDecoration(
              icon: Icon(Icons.person),
              border: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.all(Radius.circular(40)),
              ),
              labelText: 'Njord-account',
              hintText: "james.cohen.stuart",
            ),
          ).padding(all: textFormFieldPadding),
          TextFormField(
            controller: _password,
            obscureText: true,
            autocorrect: false,
            decoration: const InputDecoration(
              icon: Icon(Icons.lock),
              border: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.all(Radius.circular(40)),
              ),
              labelText: 'Wachtwoord',
              hintText: "Trekeenbak@17:26",
            ),
          ).padding(all: textFormFieldPadding),
        ].toColumn(mainAxisSize: MainAxisSize.min),
      ),
      <Widget>[
        RoundedElevatedButton(
          color: Colors.lightBlue,
          onPressed: () => login(auth, graphql),
          child: const Text("Inloggen"),
        ).height(buttonHeight).padding(all: buttonPaddding).expanded(),
        RoundedElevatedButton(
          onPressed: () => Routemaster.of(context).push('/forgot'),
          child: const Text("Vergeten"),
        ).height(buttonHeight).padding(all: buttonPaddding).expanded(),
      ].toRow(),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text("Nog geen account?"),
          InkWell(
            onTap: () {
              Routemaster.of(context).push('/register');
            },
            child: const Text(
              "Registreer",
              style: TextStyle(
                fontSize: 16,
                color: Colors.blue,
                fontWeight: FontWeight.bold,
              ),
            ).padding(horizontal: registerTextHPadding),
          ),
        ],
      ).padding(all: buttonPaddding),
    ]
        .toColumn(mainAxisSize: MainAxisSize.min)
        .padding(all: columnPadding)
        .card(
          elevation: cardElevation,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(40)),
          ),
        )
        .padding(all: cardPadding)
        .alignment(Alignment.center);
  }
}
