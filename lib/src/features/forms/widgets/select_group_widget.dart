import 'package:flutter/material.dart';
import 'package:ksrvnjord_main_app/src/features/forms/pages/create_form_page.dart';

class GroupChoices {
  static const competitie = "Competitiesectie (sjaarzenploegen & Club8+)";
  static const wedstrijd = "Wedstrijdsectie";
  static const club8Plus = "Club8+";
  static const topC4Plus = "TopC4+";
  static const sjaarzen = "Sjaarzen (werkt niet)";

  static const List<String> all = [
    competitie,
    wedstrijd,
    club8Plus,
    topC4Plus,
    sjaarzen,
  ];
}

class SelectGroupWidget extends StatelessWidget {
  const SelectGroupWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final state = context.findAncestorStateOfType<CreateFormPageState>()!;
    final groupChoices = GroupChoices
        .all; // TODO: This list should include all groups available.

    return Column(children: [
      Row(
        children: [
          Checkbox.adaptive(
            value: state.isGroupSpecific,
            onChanged: (bool? value) {
              state.updateIsGroupSpecific(value ?? false);
            },
          ),
          const Text('Formulier specifiek maken voor bepaalde groep'),
        ],
      ),
      if (state.isGroupSpecific)
        ...groupChoices.map(
          (group) => Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 64.0), // side margins
            child: CheckboxListTile(
              value: state.visibleForGroups.contains(group),
              onChanged: (bool? value) {
                state.updateGroupSettings(value ?? false, group);
              },
              title: Text(
                group,
                style: Theme.of(context).textTheme.bodySmall, // smaller text
              ),
              dense: true, // reduces vertical height of tile
              contentPadding:
                  EdgeInsets.zero, // remove internal padding if needed
            ),
          ),
        )
    ]);
  }
}
