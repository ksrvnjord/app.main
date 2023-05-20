import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/api/user_commissies.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/edit_my_profile/widgets/edit_commissies_list.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/error_card_widget.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/stream_wrapper.dart';
import 'package:routemaster/routemaster.dart';
import 'package:styled_widget/styled_widget.dart';

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
        shadowColor: Colors.transparent,
        backgroundColor: Colors.lightBlue,
        systemOverlayStyle:
            const SystemUiOverlayStyle(statusBarColor: Colors.lightBlue),
      ),
      body: ListView(children: [
        const Text('Mijn Commissies')
            .textColor(Colors.blueGrey)
            .fontSize(titleFontSize)
            .padding(all: fieldPadding),
        StreamWrapper(
          // Use stream to show updates in real time.
          stream: ref.watch(myCommissiesProvider.stream),
          success: (commissies) => EditCommissiesList(snapshot: commissies),
          error: (error) => ErrorCardWidget(errorMessage: error.toString()),
        ),
      ]),
      floatingActionButton: // Button with a plus icon and the text "Commissie".
          FloatingActionButton.extended(
        backgroundColor: Colors.lightBlue,
        onPressed: () => Routemaster.of(context).push('select'),
        icon: const Icon(Icons.add),
        label: const Text('Voeg commissie toe'),
      ),
    );
  }
}
