import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/leeden/widgets/almanak_searchable_list_widget.dart';
import 'package:ksrvnjord_main_app/src/features/shared/model/graphql_model.dart';

class AlmanakLeedenPage extends ConsumerWidget {
  const AlmanakLeedenPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final client = ref.watch(graphQLModelProvider).client;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Leeden"),
        shadowColor: Colors.transparent,
        backgroundColor: Colors.lightBlue,
        systemOverlayStyle:
            const SystemUiOverlayStyle(statusBarColor: Colors.lightBlue),
      ),
      body: AlmanakSearchableListWidget(client: client),
    );
  }
}
