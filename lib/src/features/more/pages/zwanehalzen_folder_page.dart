import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ksrvnjord_main_app/src/features/more/api/zwanehals_storage.dart';
import 'package:ksrvnjord_main_app/src/features/documents/widgets/folder_list.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/error_card_widget.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/loading_widget.dart';

class ZwanehalzenFolderPage extends ConsumerWidget {
  const ZwanehalzenFolderPage({Key? key, required this.path}) : super(key: key);

  final String path;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final rootFolder = ref.watch(zwanehalzenFolderRef(path));

    return Scaffold(
      appBar: AppBar(
        leading: path == '/'
            ? IconButton(
                onPressed: () => context.pop(),
                icon: const Icon(Icons.arrow_back),
              )
            : null,
        title: Text(path == '/' ? "Documenten" : path.replaceAll('-', ' ')),
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
        onRefresh: () => ref.refresh(zwanehalzenFolderRef(path).future),
      ),
    );
  }
}
