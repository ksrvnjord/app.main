import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/edit_my_profile/api/my_ploegen_provider.dart';
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
      body: myPloegen.when(
        data: (data) {
          return ListView.builder(
            itemCount: data.docs.length,
            itemBuilder: (context, index) {
              final doc = data.docs[index];
              print(doc.data().toJson());

              return ListTile(
                title: Text(
                  doc.data().name,
                  style: const TextStyle(
                    fontSize: titleFontSize,
                  ),
                ),
              );
            },
          );
        },
        error: (err, stk) => Text(err.toString()),
        loading: () => const CircularProgressIndicator().center(),
      ),
    );
  }
}
