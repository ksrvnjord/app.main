import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ksrv_njord_app/providers/authentication.dart';
import 'package:ksrv_njord_app/screens/main.dart';
import 'package:ksrv_njord_app/screens/login.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

Future<void> main() async {
  if (kReleaseMode) {
    // Run it inside of SentryFlutter, but log / except to the debug-app
    await SentryFlutter.init(
      (options) {
        options.dsn =
            'https://d45c56c8f63a498188d63af3c1cf585d@sentry.ksrv.nl/3';
      },
      appRunner: () => runApp(const ProviderScope(child: MyApp())),
    );
  } else {
    // Run it inside of SentryFlutter, but log / except to the debug-app
    await SentryFlutter.init(
      (options) {
        options.dsn =
            'https://d45c56c8f63a498188d63af3c1cf585d@sentry.ksrv.nl/4';
      },
      appRunner: () => runApp(const ProviderScope(child: MyApp())),
    );
  }
}

class MyApp extends HookConsumerWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authenticator = ref.watch(authenticationProvider);

    return MaterialApp(
        title: 'K.S.R.V. Njord',
        home: authenticator.loggedIn ? const MainScreen() : const LoginScreen(),
        debugShowCheckedModeBanner: false);
  }
}
