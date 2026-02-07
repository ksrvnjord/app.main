import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/widgets/verticalen_choice_list_tile.dart';
import 'package:go_router/go_router.dart';

class ManageVerticals extends ConsumerWidget {
  const ManageVerticals({
    super.key,
    required this.gender,
    required this.choices,
  });

  final String gender;
  final List<String> choices;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final genderedChoices =
        choices.where((choice) => choice.startsWith(gender)).toList();

    return Scaffold(
        appBar: AppBar(
          title: const Text("Beheer Verticalen"),
        ),
        body: Column(
          children: [
            Padding(
                padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
                child: Row(
                  children: [
                    for (final type in ['Dames', 'Heren'])
                      Padding(
                          padding: EdgeInsets.symmetric(horizontal: 4.0),
                          child: ChoiceChip(
                            label: Text(type),
                            onSelected: (selected) => context
                                .goNamed("Manage Verticals", queryParameters: {
                              'gender': type,
                            }),
                            selected: type == gender,
                          )),
                  ],
                )),
            Expanded(
              child: ListView.builder(
                  itemCount: genderedChoices.length,
                  itemBuilder: (item, index) => Column(
                        children: [
                          VerticalenChoiceListTile(
                              name: genderedChoices[index],
                              onTap: () => context.goNamed(
                                    "Edit Vertical",
                                    pathParameters: {
                                      "verticalName": genderedChoices[index]
                                    },
                                  )),
                          const Divider(height: 0, thickness: 0.5),
                        ],
                      )),
            ),
          ],
        ));
  }
}
