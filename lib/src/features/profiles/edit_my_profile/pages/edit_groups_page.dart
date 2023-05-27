import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/edit_my_profile/api/my_ploegen_provider.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/edit_my_profile/models/ploeg_entry.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/error_card_widget.dart';
import 'package:routemaster/routemaster.dart';
import 'package:styled_widget/styled_widget.dart';

class EditGroupsPage extends ConsumerWidget {
  const EditGroupsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final myPloegen = ref.watch(myPloegenProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mijn ploegen'),
      ),
      body: myPloegen.when(
        data: (data) => data.size == 0
            ? const Text('Voeg een ploeg toe om te beginnen').center()
            : ListView(
                children: [
                  data.docs.map(toListTile).toList().toColumn(),
                ],
              ),
        error: (err, stk) => ErrorCardWidget(errorMessage: err.toString()),
        loading: () => const CircularProgressIndicator().center(),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Routemaster.of(context).push('ploeg'),
        icon: const Icon(Icons.add),
        label: const Text('Voeg een ploeg toe'),
      ),
    );
  }

  ListTile toListTile(
    QueryDocumentSnapshot<PloegEntry> doc,
  ) {
    final PloegEntry entry = doc.data();
    const double titleFontSize = 20;

    return ListTile(
      leading: [
        Text(
          "${entry.year}-${entry.year + 1}",
        ),
      ].toColumn(
        mainAxisAlignment: MainAxisAlignment.center,
      ),
      title: Text(
        entry.name,
        style: const TextStyle(
          fontSize: titleFontSize,
        ),
      ),
      subtitle: Text(entry.role.value),
      trailing: IconButton(
        onPressed: () => doc.reference.delete(),
        icon: const Icon(Icons.delete),
      ),
    );
  }
}
