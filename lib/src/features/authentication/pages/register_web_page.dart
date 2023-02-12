import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';

class RegisterWebPage extends StatefulWidget {
  const RegisterWebPage({super.key});

  @override
  createState() => _RegisterWebPageState();
}

class _RegisterWebPageState extends State<RegisterWebPage> {
  @override
  void initState() {
    super.initState();

    // Enable virtual display.
    if (Platform.isAndroid) WebView.platform = AndroidWebView();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registreren'),
        backgroundColor: Colors.lightBlue,
        shadowColor: Colors.transparent,
        systemOverlayStyle:
            const SystemUiOverlayStyle(statusBarColor: Colors.lightBlue),
      ),
      body: const WebView(
        initialUrl: 'https://heimdall.njord.nl/register',
      ),
    );
  }
}
