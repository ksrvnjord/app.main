import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ksrvnjord_main_app/src/features/admin/groups/groups_provider.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/error_card_widget.dart';

class ManageGroupsPage extends ConsumerWidget {
  const ManageGroupsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final groupsVal = ref.watch(groupsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Beheer groepen'),
      ),
      body: groupsVal.when(
        data: (data) {
          return ListView.builder(
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(data[index]['name']),
                subtitle: Text(data[index]['type']),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () => context.goNamed('Edit Group', pathParameters: {
                  'id': data[index]['id'].toString(),
                }),
              );
            },
            itemCount: data.length,
          );
        },
        error: (err, stk) => ErrorCardWidget(errorMessage: err.toString()),
        loading: () =>
            const Center(child: CircularProgressIndicator.adaptive()),
      ),
      floatingActionButton: // Extended floating action button to Create a group.
          FloatingActionButton.extended(
        onPressed: () => context.goNamed('Create Group'),
        icon: const Icon(Icons.add),
        label: const Text('Nieuwe groep'),
      ),
    );
  }
}
