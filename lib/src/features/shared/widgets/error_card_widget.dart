import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:ksrvnjord_main_app/assets/images.dart';

class ErrorCardWidget extends StatelessWidget {
  const ErrorCardWidget({
    Key? key,
    required this.errorMessage,
    this.stackTrace,
  }) : super(key: key);

  final String errorMessage;
  final StackTrace? stackTrace;

  @override
  Widget build(BuildContext context) {
    final Color errorColor = Colors.red.shade800;
    const double errorCardHeight = 100;
    const double errorTitleFontSize = 18;
    const double cardBorderWidth = 2;
    // ignore: no-magic-number
    log(errorMessage, level: 2000, stackTrace: stackTrace);

    return GestureDetector(
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: errorColor, width: cardBorderWidth),
          borderRadius: const BorderRadius.all(Radius.circular(10)),
        ),
        height: errorCardHeight,
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        // ignore: sort_child_properties_last
        child: Row(children: [
          Expanded(flex: 0, child: Image.asset(Images.deadSwan)),
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    "Er is iets misgegaan",
                    style: TextStyle(
                      color: errorColor,
                      fontSize: errorTitleFontSize,
                    ),
                  ),
                  Expanded(
                    child: Container(
                      alignment: Alignment.center,
                      child: Text(
                        "Melding: $errorMessage",
                        style: const TextStyle(fontSize: 14),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ]),
        clipBehavior: Clip.antiAlias,
      ),
    );
  }
}
