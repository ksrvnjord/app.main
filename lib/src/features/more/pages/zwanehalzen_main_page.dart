import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ksrvnjord_main_app/src/features/more/api/zwanehalzen_file_page.dart';
import 'package:ksrvnjord_main_app/src/features/more/pages/zwanehalzen_folder_page.dart';

class ZwanehalzenMainPage extends StatefulWidget {
  const ZwanehalzenMainPage({Key? key}) : super(key: key);

  @override
  State<ZwanehalzenMainPage> createState() => _ZwanehalzenMainPageState();
}

class _ZwanehalzenMainPageState extends State<ZwanehalzenMainPage> {
  final _zwanehalzenNavigatorKey = GlobalKey<NavigatorState>();

  Route _onGenerateRoute(RouteSettings settings) {
    final route = ModalRoute.of(context);
    final routeName = route?.settings.name?.toLowerCase();
    debugPrint('Route name: $routeName');
    settings = RouteSettings(name: '/$routeName${settings.name ?? ''}');

    if ((settings.name ?? '').startsWith('_file/')) {
      final name = (settings.name ?? '').replaceFirst('_file/', '');

      return MaterialPageRoute(
        builder: (_) => ZwanehalzenFilePage(path: name),
        settings: settings,
      );
    }

    return MaterialPageRoute(
      builder: (_) => ZwanehalzenFolderPage(path: settings.name ?? ''),
      settings: settings,
    );
  }

  @override
  Widget build(BuildContext context) {
    // ignore: deprecated_member_use
    return WillPopScope(
      child: Navigator(
        key: _zwanehalzenNavigatorKey,
        // ignore: prefer-correct-handler-name
        onGenerateRoute: _onGenerateRoute,
      ),
      onWillPop: () async => await (_zwanehalzenNavigatorKey.currentState ==
              null
          // TODO: Use different router to don't deal with this mess of two nagivators.

          // ignore: avoid-non-null-assertion
          ? _zwanehalzenNavigatorKey.currentState!.maybePop()
          : Future.value(false)),
    );
  }
}
