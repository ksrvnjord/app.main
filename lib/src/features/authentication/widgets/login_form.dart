import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ksrvnjord_main_app/src/features/authentication/model/auth_model.dart';
import 'package:ksrvnjord_main_app/src/features/shared/model/graphql_model.dart';
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

  void login(AuthModel auth, GraphQLModel graphql) {
    auth.login(_username.text, _password.text).then((result) {
      // Also login to firebase.
      auth.firebase().then((_) => widget.loginCallback(result));
    });
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthModel>(context);
    final graphql = Provider.of<GraphQLModel>(context);

    return <Widget>[
      AnimatedBuilder(
        animation: auth,
        builder: (_, __) {
          if (auth.error != '') {
            return Text(auth.error, style: const TextStyle(color: Colors.red))
                .padding(all: 10);
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
              border: OutlineInputBorder(),
              labelText: 'Njord-account',
            ),
          ).padding(all: 10),
          TextFormField(
            controller: _password,
            obscureText: true,
            autocorrect: false,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Wachtwoord',
            ),
          ).padding(all: 10),
        ].toColumn(mainAxisSize: MainAxisSize.min),
      ),
      <Widget>[
        ElevatedButton(
          onPressed: () => login(auth, graphql),
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(Colors.lightBlue),
          ),
          child: const Text('Inloggen'),
        ).height(54).padding(all: 10).expanded(),
        ElevatedButton(
          onPressed: () {
            Routemaster.of(context).push('/forgot');
          },
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(Colors.blueGrey),
          ),
          child: const Text('Vergeten'),
        ).height(54).padding(all: 10).expanded(),
      ].toRow(),
    ]
        .toColumn(mainAxisSize: MainAxisSize.min)
        .padding(all: 20)
        .card(
          elevation: 10,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
        )
        .padding(all: 12)
        .alignment(Alignment.center);
  }
}
