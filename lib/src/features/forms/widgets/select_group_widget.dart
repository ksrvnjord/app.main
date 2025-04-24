import 'package:flutter/material.dart';

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
    required this.onChanged,
    this.visibleForGroups = const [],
    super.key,
  });

  final void Function(List<String>) onChanged;
  final List<String> visibleForGroups;

  @override
  Widget build(BuildContext context) {
    final groupChoices = GroupChoices
        .all; // TODO: This list should include all groups available.
    final newGroups = visibleForGroups;

    return Column(
      children: groupChoices
          .map((group) => CheckboxListTile(
                value: newGroups.contains(group),
                onChanged: ((bool? value) => {
                      if (value ?? false) {newGroups.add(group)},
                      if (!(value ?? true) && newGroups.contains(group))
                        {newGroups.remove(group)},
                      onChanged(newGroups),
                    }),
                title: Text(group),
              ))
          .toList(),
    );
  }
}
