import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ksrvnjord_main_app/src/features/authentication/model/auth_model.dart';
import 'package:ksrvnjord_main_app/src/features/shared/model/graphql_model.dart';
import 'package:provider/provider.dart';
import 'package:routemaster/routemaster.dart';
import 'package:styled_widget/styled_widget.dart';

class ForgotForm extends StatefulWidget {
  static const routename = '/login/forgot';
  const ForgotForm({super.key});

  @override
  createState() => _ForgotFormState();
}

class _ForgotFormState extends State<ForgotForm> {
  final GlobalKey<FormState> _formKey =
      GlobalKey(debugLabel: 'ForgotPasswordForm');

  final _username = TextEditingController();
  String error = '';
  String message = '';

  // ignore: no-empty-block
  void forgot(AuthModel auth, GraphQLModel graphql) {}

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthModel>(context);
    final graphql = Provider.of<GraphQLModel>(context);

    return <Widget>[
      error != ''
          ? Text(auth.error, style: const TextStyle(color: Colors.red))
              .padding(all: 10)
          : Container(),
      message != ''
          ? Text(auth.error, style: const TextStyle(color: Colors.blue))
              .padding(all: 10)
          : Container(),
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
        ].toColumn(mainAxisSize: MainAxisSize.min),
      ),
      <Widget>[
        ElevatedButton(
          onPressed: () => forgot(auth, graphql),
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(Colors.lightBlue),
          ),
          child: const Text('Wachtwoord vergeten'),
        ).height(54).padding(all: 10).expanded(),
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: Colors.blueGrey),
          onPressed: () {
            Routemaster.of(context).pop();
          },
          child: const Icon(Icons.arrow_back),
        ).height(54).padding(all: 10),
      ].toRow(),
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
}
