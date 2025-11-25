import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
//import 'package:ksrvnjord_main_app/src/features/profiles/api/substructure_picture_provider.dart';
//import 'package:ksrvnjord_main_app/src/features/profiles/widgets/verticalen_choice_list_tile.dart';
import 'package:styled_widget/styled_widget.dart';

class VerticaalChoicePage extends ConsumerWidget {
  const VerticaalChoicePage({
    super.key,
    required this.title,
    required this.gender,
    required this.choices,
  });

  final String title;
  final String gender;
  final List<String> choices;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const double wrapSpacing = 8;

    final genderedChoices = choices
        .where(
          (choice) => choice.startsWith(gender == "Mannen" ? "Heren" : "Dames"),
        )
        .toList();

    return Scaffold(
        appBar: AppBar(
          title: Text("Kies een verticaal"),
        ),
        body: Column(children: [
          Padding(
            padding: const EdgeInsets.only(top: 8, bottom: 8),
            child: Row(
              children: [
                for (final genderOption in ["Mannen", "Vrouwen"])
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: wrapSpacing / 2),
                    child: ChoiceChip(
                      label: Text(genderOption),
                      onSelected: (selected) =>
                          context.goNamed("Verticals", queryParameters: {
                        'gender': genderOption,
                      }),
                      selected: genderOption == gender,
                    ),
                  ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemBuilder: (context, index) => [
                /*VerticalenChoiceListTile(
                  name: genderedChoices[index], 
                  imageProvider: 
                      ref.watch(verticalsPictureProvider(genderedChoices[index])), 
                  onTap: () => context.goNamed(
                    "Verticaal",
                    pathParameters: {"name": genderedChoices[index]},
                  ),
                ),*/
                const Divider(height: 0, thickness: 0.5),
              ].toColumn(),
              itemCount: genderedChoices.length,
            ),
          )
        ]));
  }
}
