import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ksrvnjord_main_app/src/features/gallery/api/gallery_storage.dart';
import 'package:ksrvnjord_main_app/src/features/gallery/widgets/folder_list.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/loading_widget.dart';
import 'package:routemaster/routemaster.dart';

class GalleryFolderPage extends ConsumerWidget {
  final String path;

  const GalleryFolderPage({
    Key? key,
    required this.path,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final rootFolder = ref.watch(galleryFolderRef(path));

    return Scaffold(
      appBar: AppBar(
        leading: path ==
                '/' // Lousy fix for having a Navigator in the GalleryMainPage so we can navigate back out of the gallery
            ? IconButton(
                onPressed: () => Routemaster.of(context).pop(),
                icon: const Icon(Icons.arrow_back),
              )
            : null,
        title: Text(path == '/' ? "Galerij" : path.replaceAll('-', ' ')),
        backgroundColor: Colors.lightBlue,
        shadowColor: Colors.transparent,
        actions: [
          IconButton(
            onPressed: () => ref.refresh(galleryFolderRef(path)),
            icon: const Icon(Icons.refresh),
          ),
        ],
        systemOverlayStyle:
            const SystemUiOverlayStyle(statusBarColor: Colors.lightBlue),
      ),
      body: rootFolder.when(
        data: (listResult) => FolderList(
          listResult: listResult,
        ),
        error: (err, trace) => Text(err.toString()),
        loading: () => const LoadingWidget(),
      ),
    );
  }
}
