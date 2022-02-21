import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:ksrvnjord_main_app/widgets/images/splash_logo.dart';
import 'package:ksrvnjord_main_app/assets/images.dart';
import 'package:ksrvnjord_main_app/providers/authentication.dart';
import 'package:ksrvnjord_main_app/pages/login/dev.dart';

class LoginScreen extends StatefulHookConsumerWidget {
  static const routename = '/login';
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey(debugLabel: 'LoginForm');

  final _username = TextEditingController();
  final _password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final authentication = ref.watch(authenticationProvider);
    authentication.loginFromStorage();

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 128,
        title: const Center(child: SplashLogoWidget(image: Images.appLogo)),
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
                                    ElevatedButton(
                                        onPressed: () {
                                          launch(
                                              'https://heimdall.njord.nl/forgot-password');
                                        },
                                        style: ElevatedButton.styleFrom(
                                            primary: Colors.blue),
                                        child: const Text('Ga naar website'))
                                  ]));
                    },
                    child: const Text('?'))),
            !kReleaseMode
                ? Container(
                    margin: const EdgeInsets.only(left: 8),
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(primary: Colors.red),
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (_) => AlertDialog(
                                      title: const Text(
                                          'Verbinden met een ontwikkelomgeving'),
                                      content: const Text(
                                          'De app bevindt zich in ontwikkelmodus, verbind '
                                          'met een ontwikkelomgeving.'),
                                      actions: [
                                        ElevatedButton(
                                            onPressed: () {
                                              showDialog(
                                                  context: context,
                                                  builder: (_) => const AlertDialog(
                                                      title:
                                                          Text('Development'),
                                                      content:
                                                          SelectDevelopmentServer()));
                                            },
                                            child: const Icon(Icons.settings))
                                      ]));
                        },
                        child: const Icon(Icons.settings)))
                : Container()
          ]),
        ),
      ]),
    );
  }
}
