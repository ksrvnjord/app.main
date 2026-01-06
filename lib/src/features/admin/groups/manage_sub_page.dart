import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/data/substructures.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/data/houses.dart';

class ManageSubPage extends ConsumerWidget {
  const ManageSubPage({
    super.key,
    this.type,
  });

  final String? type;
  static const String typeSubstructuren = "Substructuren";
  static const String typeHuizen = "Huizen";

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const double wrapSpacing = 8;
    const double wrapPadding = 8;
    final String selectedType = type ?? typeSubstructuren;

    final List<String> allSubstructures = selectedType == typeSubstructuren
        ? substructures.toList()
        : kHouseNames;

    return Scaffold(
      appBar: AppBar(
        title: Text("Beheer $selectedType"),
      ),
      body: Column(children: [
        [
          for (final choiceType in [typeSubstructuren, typeHuizen]) ...[
            ChoiceChip(
              label: Text(choiceType),
              onSelected: (selected) => context.goNamed(
                'Manage Substructuren',
                queryParameters: {
                  'type': choiceType == selectedType ? null : choiceType,
                },
              ),
              selected: choiceType == selectedType,
            ),
          ]
        ]
            .toWrap(
              spacing: wrapSpacing,
            )
            .paddingDirectional(horizontal: wrapPadding),
        Expanded(
          child: ListView.builder(
              itemCount: allSubstructures.length,
              itemBuilder: (context, index) {
                final String substructureName =
                    allSubstructures.elementAt(index);
                return Card(
                  child: ListTile(
                      title: Text(substructureName),
                      trailing: const Icon(Icons.arrow_forward_ios),
                      onTap: () {
                        context.goNamed("Edit Substructure", pathParameters: {
                          "substructureName": substructureName,
                        }, queryParameters: {
                          'type': selectedType,
                        });
                      }),
                );
              }),
        ),
      ]),
    );
  }
}
