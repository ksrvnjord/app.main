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

  @override
  Widget build(BuildContext context) {
    // ignore: deprecated_member_use
    return WillPopScope(
      child: Navigator(
        key: _zwanehalzenNavigatorKey,
        // TODO: Fix ignore below.
        // ignore: prefer-correct-handler-name
        onGenerateRoute: onGenerateRoute,
      ),
      // TODO: Fix ignore below.
      // ignore: avoid-negated-conditions
      onWillPop: () async => !await (_zwanehalzenNavigatorKey.currentState !=
              null
          // TODO: Use different router to don't deal with this mess of two nagivators.

          // ignore: avoid-non-null-assertion
          ? _zwanehalzenNavigatorKey.currentState!.maybePop()
          : Future.value(false)),
    );
  }

  // TODO: Fix ignore below.
  // ignore: prefer-widget-private-members
  Route onGenerateRoute(RouteSettings settings) {
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
}
