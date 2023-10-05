import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ksrvnjord_main_app/src/features/gallery/api/gallery_storage.dart';
import 'package:ksrvnjord_main_app/src/features/gallery/widgets/folder_list.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/loading_widget.dart';

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
        leading: path == '/'
            ? IconButton(
                onPressed: () => context.pop(),
                icon: const Icon(Icons.arrow_back),
              )
            : null,
        title: Text(path == '/' ? "Galerij" : path.replaceAll('-', ' ')),
        actions: [
          IconButton(
            onPressed: () => ref.refresh(galleryFolderRef(path)),
            icon: const Icon(Icons.refresh),
          ),
        ],
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
