import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ErrorTextWidget extends StatelessWidget {
  const ErrorTextWidget({
    super.key,
    required this.errorMessage,
    this.stackTrace,
  });

  final String errorMessage;
  final StackTrace? stackTrace;

  @override
  Widget build(BuildContext context) {
    // ignore: no-magic-number
    log(errorMessage, level: 2000, stackTrace: stackTrace);

    return GestureDetector(
      onTap: () => launchUrl(Uri.parse(_handleErrorLink(errorMessage))),
      child: Text('Error: $errorMessage'),
    );
  }
}

String _handleErrorLink(String errorMessage) {
  final RegExp urlRegExp = RegExp(
    r'http[s]?://[^\s]+',
    caseSensitive: false,
  );
  final match = urlRegExp.firstMatch(errorMessage);
  debugPrint(match.toString());
  if (match != null) {
    final url = match.group(0);
    if (url != null) {
      return url;
    }
  }
  return 'https://youtube.com/shorts/snGnJKKcMOk?si=vQFTVKE6sfJJMslZ';
}
