import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ksrvnjord_main_app/src/features/admin/groups/groups_provider.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/error_card_widget.dart';

/// Page to perform CRD operations on group-members for a specific group (which is a year and groupname).
class EditGroupPage extends ConsumerWidget {
  final String groupId;

  const EditGroupPage({Key? key, required this.groupId}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final groupVal = ref.watch(groupByIdProvider(groupId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit groep leden'),
      ),
      body: groupVal.when(
        data: (data) {
          return ListView.builder(
            itemBuilder: (context, index) {
              final user = data[index]['user'];

              return ListTile(
                title: Text(user['first_name'] + ' ' + user['last_name']),
                subtitle: Text(data[index]['year'].toString()),
                // TODO: add delete functionality to delete button
                // trailing: const Icon(Icons.delete),
              );
            },
            itemCount: data.length,
          );
        },
        error: (err, stk) => ErrorCardWidget(errorMessage: err.toString()),
        loading: () =>
            const Center(child: CircularProgressIndicator.adaptive()),
      ),
    );
  }
}
