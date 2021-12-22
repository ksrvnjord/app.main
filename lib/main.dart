import 'package:flutter/material.dart';
import 'package:ksrv_njord_app/pages/home.dart';
import 'package:ksrv_njord_app/pages/auth.dart';
import 'package:ksrv_njord_app/pages/announcements.dart';
import 'package:ksrv_njord_app/pages/vaarverbod.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'K.S.R.V. Njord',
        initialRoute: '/vaarverbod',
        routes: {
          '/auth': (context) => const AuthPage(),
          '/': (context) => const HomePage(),
          '/announcements': (context) => const AnnouncementsPage(),
          '/vaarverbod': (context) => const Vaarverbod(),
        },
        debugShowCheckedModeBanner: false);
  }
}
