import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/edit_my_profile/api/my_ploegen_provider.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/error_card_widget.dart';
import 'package:routemaster/routemaster.dart';
import 'package:styled_widget/styled_widget.dart';

class EditGroupsPage extends ConsumerWidget {
  const EditGroupsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const double titleFontSize = 20;

    final myPloegen = ref.watch(myPloegenProvider);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlue,
        shadowColor: Colors.transparent,
        systemOverlayStyle:
            const SystemUiOverlayStyle(statusBarColor: Colors.lightBlue),
        title: const Text(
          'Mijn ploegen',
        ), // TODO: in the future make this My groups as this page will serve as a hub for all groups
      ),
      body: ListView(
        children: [
          myPloegen.when(
            data: (data) => data.docs
                .map((doc) => ListTile(
                      leading: [
                        Text(
                          "${doc.data().year}-${doc.data().year + 1}",
                        ),
                      ].toColumn(mainAxisAlignment: MainAxisAlignment.center),
                      title: Text(
                        doc.data().name,
                        style: const TextStyle(
                          fontSize: titleFontSize,
                        ),
                      ),
                      subtitle: Text(doc.data().role.value),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () => doc.reference.delete(),
                      ),
                    ))
                .toList()
                .toColumn(),
            error: (err, stk) => ErrorCardWidget(errorMessage: err.toString()),
            loading: () => const CircularProgressIndicator().center(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Routemaster.of(context).push('ploeg'),
        label: const Text('Voeg een ploeg toe'),
        icon: const Icon(Icons.add),
        backgroundColor: Colors.blue,
      ),
    );
  }
}
