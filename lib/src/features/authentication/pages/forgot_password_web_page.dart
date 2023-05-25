import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ForgotPasswordWebPage extends StatefulWidget {
  const ForgotPasswordWebPage({super.key});

  @override
  createState() => _ForgotPasswordWebPageState();
}

class _ForgotPasswordWebPageState extends State<ForgotPasswordWebPage> {
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
        title: const Text('Wachtwoord vergeten'),
        backgroundColor: Colors.lightBlue,
        shadowColor: Colors.transparent,
        systemOverlayStyle:
            const SystemUiOverlayStyle(statusBarColor: Colors.lightBlue),
      ),
      body: const WebView(
        initialUrl: 'https://heimdall.njord.nl/forgot-password',
      ),
    );
  }
}