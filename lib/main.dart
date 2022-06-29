import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ksrvnjord_main_app/providers/authentication.dart';
import 'package:ksrvnjord_main_app/push_notifications.dart';
import 'package:ksrvnjord_main_app/screens/main.dart';
import 'package:ksrvnjord_main_app/screens/login.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  PushNotificationsManager().init();
  if (kReleaseMode) {
    // Run it inside of SentryFlutter, but log / except to the debug-app
    await SentryFlutter.init(
      (options) {
        options.dsn =
            'https://d45c56c8f63a498188d63af3c1cf585d@sentry.ksrv.nl/3';
        options.tracesSampleRate = 0.1;
      },
      appRunner: () => runApp(const ProviderScope(child: MyApp())),
    );
  } else {
    // Running in debug, no need to send exceptions to Sentry
    runApp(const ProviderScope(child: MyApp()));
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
      debugShowCheckedModeBanner: false,
    );
  }
}
