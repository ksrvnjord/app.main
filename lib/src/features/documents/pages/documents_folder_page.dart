import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ksrvnjord_main_app/src/features/documents/api/documents_storage.dart';
import 'package:ksrvnjord_main_app/src/features/documents/widgets/folder_list.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/error_card_widget.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/loading_widget.dart';

class DocumentsFolderPage extends ConsumerWidget {
  const DocumentsFolderPage({
    Key? key,
    required this.path,
    required this.rootPath,
  }) : super(key: key);

  final String path;
  final String rootPath;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final rootFolder = ref.watch(documentsFolderRef(path));

    final storageNameToAppNameMap = {'zwanehalzen': 'Zwanehalzen'};

    final appFolderName = storageNameToAppNameMap[rootPath] ?? 'Documenten';

    return Scaffold(
      appBar: AppBar(
        leading: path == '$rootPath//'
            ? IconButton(
                onPressed: () => context.pop(),
                icon: const Icon(Icons.arrow_back),
              )
            : null,
        title: Text(path == '$rootPath//'
            ? appFolderName
            : path.replaceAll('-', ' ').replaceAll('$rootPath/', '')),
      ),
      body: RefreshIndicator(
        child: rootFolder.when(
          data: (listResult) => FolderList(listResult: listResult),
          error: (err, trace) => ErrorCardWidget(
            errorMessage: err.toString(),
            stackTrace: trace,
          ),
          loading: () => const LoadingWidget(),
        ),
        onRefresh: () => ref.refresh(documentsFolderRef(path).future),
      ),
    );
  }
}
