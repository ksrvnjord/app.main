import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ksrvnjord_main_app/src/features/documents/api/documents_storage.dart';
import 'package:ksrvnjord_main_app/src/features/documents/widgets/folder_list.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/loading_widget.dart';
import 'package:routemaster/routemaster.dart';

class DocumentsFolderPage extends ConsumerWidget {
  final String path;

  const DocumentsFolderPage({
    Key? key,
    required this.path,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final rootFolder = ref.watch(documentsFolderRef(path));

    return Scaffold(
      appBar: AppBar(
        leading: path == '/'
            ? IconButton(
                onPressed: () => Routemaster.of(context).pop(),
                icon: const Icon(Icons.arrow_back),
              )
            : null,
        title: Text(path == '/' ? "Documenten" : path.replaceAll('-', ' ')),
        actions: [
          IconButton(
            onPressed: () => ref.refresh(documentsFolderRef(path)),
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
