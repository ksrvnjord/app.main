import 'package:flutter/material.dart';
import 'package:ksrvnjord_main_app/src/features/gallery/pages/gallery_file_page_view.dart';
import 'package:ksrvnjord_main_app/src/features/gallery/pages/gallery_folder_page.dart';

class GalleryMainPage extends StatefulWidget {
  const GalleryMainPage({super.key});

  @override
  State<GalleryMainPage> createState() => _GalleryMainPageState();
}

class _GalleryMainPageState extends State<GalleryMainPage> {
  final _galleryNavigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    // ignore: deprecated_member_use
    return WillPopScope(
      child: Navigator(
        key: _galleryNavigatorKey,
        onGenerateRoute: onGenerateRoute,
      ),
      onWillPop: () async => !await (_galleryNavigatorKey.currentState != null
          // TODO: Use different router to don't deal with this mess of two nagivators.

          // ignore: avoid-non-null-assertion
          ? _galleryNavigatorKey.currentState!.maybePop()
          : Future.value(false)),
    );
  }

  Route onGenerateRoute(RouteSettings settings) {
    if ((settings.name ?? '').startsWith('_file/')) {
      // ignore: avoid-type-casts
      final arguments = settings.arguments as Map<String, dynamic>;

      return MaterialPageRoute(
        builder: (_) => GalleryFilePageView(
          initialIndex: arguments['initialIndex'],
          paths: arguments['paths'],
        ),
        settings: settings,
      );
    }

    return MaterialPageRoute(
      builder: (_) => GalleryFolderPage(path: settings.name ?? ''),
      settings: settings,
    );
  }
}
