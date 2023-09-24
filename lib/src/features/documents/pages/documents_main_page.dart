import 'package:flutter/material.dart';
import 'package:ksrvnjord_main_app/src/features/documents/pages/documents_file_page.dart';
import 'package:ksrvnjord_main_app/src/features/documents/pages/documents_folder_page.dart';

class DocumentsMainPage extends StatefulWidget {
  const DocumentsMainPage({
    Key? key,
  }) : super(key: key);

  @override
  State<DocumentsMainPage> createState() => _DocumentsMainPageState();
}

class _DocumentsMainPageState extends State<DocumentsMainPage> {
  final _documentsNavigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    // ignore: deprecated_member_use
    return WillPopScope(
      child: Navigator(
        key: _documentsNavigatorKey,
        onGenerateRoute: onGenerateRoute,
      ),
      onWillPop: () async => !await (_documentsNavigatorKey.currentState != null

          // TODO: Use different router to don't deal with this mess of two nagivators.

          // ignore: avoid-non-null-assertion
          ? _documentsNavigatorKey.currentState!.maybePop()
          : Future.value(false)),
    );
  }

  Route onGenerateRoute(RouteSettings settings) {
    if ((settings.name ?? '').startsWith('_file/')) {
      final name = (settings.name ?? '').replaceFirst('_file/', '');

      return MaterialPageRoute(
        builder: (_) => DocumentsFilePage(path: name),
        settings: settings,
      );
    }

    return MaterialPageRoute(
      builder: (_) => DocumentsFolderPage(path: settings.name ?? ''),
      settings: settings,
    );
  }
}
