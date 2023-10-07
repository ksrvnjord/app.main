import 'dart:developer';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ksrvnjord_main_app/assets/images.dart';
import 'package:styled_widget/styled_widget.dart';

class UnknownRoutePage extends StatelessWidget {
  const UnknownRoutePage({super.key});

  @override
  Widget build(BuildContext context) {
    const double padding = 16;
    final textTheme = Theme.of(context).textTheme;

    log(
      "404: ${GoRouter.of(context).routeInformationProvider.value.uri.path} not found)}",
      // ignore: no-magic-number
      level: 2000,
      name: 'Unknown Route',
    );

    final canPop = context.canPop();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pagina niet gevonden'),
      ),
      body: [
        Text(
          'Deze pagina lijkt helaas niet (meer) te bestaan.',
          style: textTheme.headlineSmall,
          textAlign: TextAlign.center,
        ).padding(all: padding),
        Text(
          'Er is een melding van gemaakt voor de Appcommissie om te onderzoeken.',
          style: textTheme.labelLarge,
          textAlign: TextAlign.center,
        ).padding(horizontal: padding),
        Image.asset(
          Images.unknownRoute404,
          fit: BoxFit.cover,
        ),
      ].toColumn(
        mainAxisAlignment: MainAxisAlignment.center,
      ),
      floatingActionButton: FloatingActionButton.extended(
        // ignore: prefer-extracting-callbacks
        onPressed: () {
          if (!kDebugMode) {
            // Report error in Routing to Crashlytics in production.
            FirebaseCrashlytics.instance.recordError(
              "404: ${GoRouter.of(context).routeInformationProvider.value.uri.path} not found)}",
              StackTrace.empty,
              reason: 'because of invalid route',
            );
          }
          if (canPop) {
            // Going back is preferred for UX, but not always possible.
            context.pop();
          } else {
            context.go('/');
          }
        },
        icon: canPop ? const Icon(Icons.arrow_back) : const Icon(Icons.home),
        label:
            canPop ? const Text('Ga terug') : const Text('Ga naar dashboard'),
      ),
    );
  }
}
