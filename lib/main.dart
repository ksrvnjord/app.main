import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:ksrv_njord_app/pages/home.dart';
import 'package:ksrv_njord_app/pages/login.dart';
import 'package:ksrv_njord_app/pages/announcements.dart';
import 'package:ksrv_njord_app/providers/authentication.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends HookConsumerWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authenticator = ref.watch(authenticationProvider);

    return MaterialApp(
        title: 'K.S.R.V. Njord',
        initialRoute: '/',
        home: authenticator.loggedIn ? const HomePage() : const LoginPage(),
        routes: authenticator.loggedIn
            ? {
                '/announcements': (context) => const AnnouncementsPage(),
              }
            : {},
        debugShowCheckedModeBanner: false);
  }
}
