import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/leeden/widgets/almanak_searchable_list_widget.dart';
import 'package:ksrvnjord_main_app/src/features/shared/model/graphql_model.dart';

class AlmanakLeedenPage extends ConsumerWidget {
  const AlmanakLeedenPage({Key? key, this.onTap}) : super(key: key);

  final void Function(int)? onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final client = ref.watch(graphQLClientProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Leeden"),
      ),
      body: AlmanakSearchableListWidget(client: client, onTap: onTap),
    );
  }
}
