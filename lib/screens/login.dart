import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:ksrv_njord_app/assets/images.dart';
import 'package:ksrv_njord_app/widgets/app_icon_widget.dart';
import 'package:ksrv_njord_app/providers/authentication.dart';

class LoginScreen extends StatefulHookConsumerWidget {
  static const routename = '/login';
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey();

  final _username = TextEditingController();
  final _password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 128,
        title: const Center(child: AppIconWidget(image: Images.appLogo)),
        backgroundColor: Colors.lightBlue,
        shadowColor: Colors.transparent,
        systemOverlayStyle:
            const SystemUiOverlayStyle(statusBarColor: Colors.lightBlue),
      ),
      backgroundColor: Colors.white,
      body: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Form(
            key: _formKey,
            child: Column(children: [
              Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: TextFormField(
                    controller: _username,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.allow(RegExp('[a-z.@]')),
                    ],
                    obscureText: false,
                    autocorrect: false,
                    enableSuggestions: false,
                    textCapitalization: TextCapitalization.none,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: '@leden.ksrv.nl-account',
                    ),
                  )),
              Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: TextFormField(
                    controller: _password,
                    obscureText: true,
                    autocorrect: false,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Wachtwoord',
                    ),
                  ))
            ])),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Expanded(
              child: ElevatedButton(
                  onPressed: () {
                    final authentication = ref.watch(authenticationProvider);
                    authentication
                        .attemptLogin(_username.text, _password.text)
                        .then((loggedIn) => {
                              if (loggedIn != 'OK')
                                {
                                  showDialog(
                                      context: context,
                                      builder: (_) => AlertDialog(
                                          title: const Text('Inloggen mislukt'),
                                          content: Text(loggedIn)))
                                }
                            });
                    // Navigator.popAndPushNamed(context, '/');
                  },
                  child: const Text('Inloggen')),
            ),
            Container(
                margin: const EdgeInsets.only(left: 8),
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(primary: Colors.black),
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (_) => AlertDialog(
                                  title: const Text('Wachtwoord Vergeten?'),
                                  content: const Text(
                                      'Een wachtwoordreset via de app is nog '
                                      'niet mogelijk, dit kan wel via de site.'),
                                  actions: [
                                    TextButton(
                                        onPressed: () {
                                          launch(
                                              'https://heimdall.njord.nl/forgot-password');
                                        },
                                        child: const Text('Ga naar website')),
                                    TextButton(
                                        child: const Text('Annuleer'),
                                        onPressed: () => Navigator.pop(context))
                                  ]));
                    },
                    child: const Text('?')))
          ]),
        ),
      ]),
    );
  }
}
