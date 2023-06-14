import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/api/njord_year.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/api/substructure_picture_provider.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/substructures/api/commissie_info_provider.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/widgets/substructure_choice_list_tile.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/error_card_widget.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:tuple/tuple.dart';

/// Page that shows a list of choices, and pushes a new page when a choice is chosen.
class CommissieChoicePage extends ConsumerWidget {
  const CommissieChoicePage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final commissies = ref.watch(commissieNamesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Commissies"),
      ),
      body: commissies.when(
        data: (choices) => ListView.builder(
          itemBuilder: (context, index) => [
            SubstructureChoiceListTile(
              name: choices.elementAt(index),
              imageProvider: ref.watch(commissieThumbnailProvider(
                Tuple2(choices.elementAt(index), getNjordYear()),
              )),
            ),
            const Divider(height: 0, thickness: 0.5),
          ].toColumn(),
          itemCount: choices.length,
        ),
        error: (err, __) => ErrorCardWidget(errorMessage: err.toString()),
        loading: () => const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
