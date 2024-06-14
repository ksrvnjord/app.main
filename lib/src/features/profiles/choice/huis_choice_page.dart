import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/substructures/api/huis_picture_provider.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/widgets/substructure_choice_list_tile.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:tuple/tuple.dart';

/// Page that shows a list of choices, and pushes a new page when a choice is chosen.
class HuisChoicePage extends ConsumerWidget {
  const HuisChoicePage({
    super.key,
    required this.title,
    required this.choices,
  });

  final String title;
  final List<String> choices;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: ListView.builder(
        itemBuilder: (context, index) => [
          SubstructureChoiceListTile(
            name: choices[index],
            imageProvider: ref.watch(huisThumbnailProvider(
              Tuple2(
                choices[index],
                // ignore: no-magic-number
                2022,
              ), // TODO: hardcoded year, we keep this until huizen can edit their own info.
            )),
            onTap: () => context
                .goNamed("Huis", pathParameters: {"name": choices[index]}),
          ),
          const Divider(height: 0, thickness: 0.5),
        ].toColumn(),
        itemCount: choices.length,
      ),
    );
  }
}
