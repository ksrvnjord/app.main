import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ksrvnjord_main_app/src/features/gallery/api/gallery_storage.dart';
import 'package:ksrvnjord_main_app/src/features/gallery/utils/gallery_view_provider.dart';
import 'package:ksrvnjord_main_app/src/features/gallery/widgets/image_folder_list.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/error_text_widget.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/loading_widget.dart';

class GalleryFolderPage extends ConsumerWidget {
  const GalleryFolderPage({super.key, required this.path});

  final String path;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final rootFolder = ref.watch(galleryFolderRef("galerij/$path"));

    final gridOrList = ref.watch(gridOrListViewProvider);

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
            onPressed: () =>
                ref.read(gridOrListViewProvider.notifier).state = !gridOrList,
            icon: Icon(gridOrList ? Icons.grid_view_rounded : Icons.list),
          ),
        ],
      ),
      body: rootFolder.when(
        data: (listResult) => ImageFolderList(listResult: listResult),
        error: (err, trace) => ErrorTextWidget(errorMessage: err.toString()),
        loading: () => const LoadingWidget(),
      ),
    );
  }
}
