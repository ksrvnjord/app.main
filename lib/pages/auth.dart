import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ksrv_njord_app/assets/images.dart';
import 'package:ksrv_njord_app/widgets/app_icon_widget.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({Key? key}) : super(key: key);

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
        Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: const TextField(
              obscureText: false,
              autocorrect: false,
              autofillHints: ['mail'],
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: '@leden.ksrv.nl-account',
              ),
            )),
        Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: const TextField(
              obscureText: true,
              autocorrect: false,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Wachtwoord',
              ),
            )),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Expanded(
              child: ElevatedButton(
                  onPressed: () {
                    Navigator.popAndPushNamed(context, '/');
                  },
                  child: const Text('Inloggen')),
            ),
            Container(
                margin: const EdgeInsets.only(left: 8),
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(primary: Colors.black),
                    onPressed: () {
                      Navigator.popAndPushNamed(context, '/');
                    },
                    child: const Text('?')))
          ]),
        ),
      ]),
    );
  }
}
