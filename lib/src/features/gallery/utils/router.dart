import 'package:flutter/material.dart';
import 'package:ksrvnjord_main_app/src/features/gallery/pages/gallery_file_page.dart';
import 'package:ksrvnjord_main_app/src/features/gallery/pages/gallery_folder_page.dart';

Route onGenerateRoute(RouteSettings settings) {
  if ((settings.name ?? '').startsWith('_file/')) {
    final name = (settings.name ?? '').replaceFirst('_file/', '');

    return MaterialPageRoute(
      builder: (_) => GalleryFilePage(path: name),
      settings: settings,
    );
  }

  return MaterialPageRoute(
    builder: (_) => GalleryFolderPage(path: settings.name ?? 'galerij'),
    settings: settings,
  );
}
