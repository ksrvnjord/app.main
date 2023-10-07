import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/api/user_commissies.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/edit_my_profile/widgets/edit_commissies_list.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/error_card_widget.dart';

class EditCommissiesPage extends ConsumerStatefulWidget {
  const EditCommissiesPage({Key? key}) : super(key: key);

  @override
  EditCommissiesPageState createState() => EditCommissiesPageState();
}

class EditCommissiesPageState extends ConsumerState<EditCommissiesPage> {
  static const double fieldPadding = 8;
  static const double titleFontSize = 20;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Commissies'),
      ),
      body: ListView(children: [
        ref.watch(myCommissiesProvider).when(
              loading: () =>
                  const Center(child: CircularProgressIndicator.adaptive()),
              // Use stream to show updates in real time.
              data: (commissies) => EditCommissiesList(snapshot: commissies),
              error: (error, stk) => ErrorCardWidget(
                errorMessage: error.toString(),
                stackTrace: stk,
              ),
            ),
      ]),
      floatingActionButton: // Button with a plus icon and the text "Commissie".
          FloatingActionButton.extended(
        onPressed: () => context.goNamed('Select Commissie'),
        icon: const Icon(Icons.add),
        label: const Text('Voeg commissie toe'),
      ),
    );
  }
}
