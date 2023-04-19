import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ksrvnjord_main_app/src/features/gallery/api/gallery_root_folder.dart';
import 'package:ksrvnjord_main_app/src/features/gallery/widgets/folder_list.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/loading_widget.dart';

class GalleryPage extends ConsumerWidget {
  const GalleryPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final rootFolder = ref.watch(galleryRootFolderRef);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Fotoalbum'),
        backgroundColor: Colors.lightBlue,
        shadowColor: Colors.transparent,
        actions: [
          IconButton(
            onPressed: () => ref.refresh(galleryRootFolderRef),
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
