import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ksrv_njord_app/providers/authentication.dart';
import 'package:ksrv_njord_app/screens/main.dart';
import 'package:ksrv_njord_app/screens/login.dart';

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
        home: authenticator.loggedIn ? const MainScreen() : const LoginScreen(),
        debugShowCheckedModeBanner: false);
  }
}
