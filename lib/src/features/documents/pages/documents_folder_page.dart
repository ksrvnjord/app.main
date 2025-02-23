import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ksrvnjord_main_app/src/features/documents/api/documents_storage.dart';
import 'package:ksrvnjord_main_app/src/features/documents/widgets/document_folder_list.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/error_card_widget.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/loading_widget.dart';

class DocumentsFolderPage extends ConsumerWidget {
  const DocumentsFolderPage({
    super.key,
    required this.path,
    required this.rootPath,
  });

  final String path;
  final String rootPath;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final rootFolder = ref.watch(documentsFolderRef(path));

    final appFolderName = {
      'documents': 'Documenten',
      'zwanehalzen': 'Zwanehalzen',
    }[rootPath];

    if (appFolderName == null) {
      throw UnimplementedError(
        'No app folder name found for rootPath: $rootPath',
      );
    }

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
            : path.replaceAll('-', ' ').replaceFirst('$rootPath/', '')),
      ),
      body: RefreshIndicator(
        child: rootFolder.when(
          data: (listResult) => DocumentFolderList(listResult: listResult),
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
