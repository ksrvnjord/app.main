import 'package:flutter/material.dart';
import 'package:ksrvnjord_main_app/src/features/gallery/utils/router.dart';

final _galleryNavigatorKey = GlobalKey<NavigatorState>();

class GalleryMainPage extends StatefulWidget {
  const GalleryMainPage({
    Key? key,
  }) : super(key: key);

  @override
  State<GalleryMainPage> createState() => _GalleryMainPageState();
}

class _GalleryMainPageState extends State<GalleryMainPage> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => !await (_galleryNavigatorKey.currentState != null
          ? _galleryNavigatorKey.currentState!.maybePop()
          : Future.value(false)),
      child: Navigator(
        key: _galleryNavigatorKey,
        onGenerateRoute: onGenerateRoute,
      ),
    );
  }
}
