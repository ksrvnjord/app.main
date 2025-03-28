import 'package:flutter/material.dart';

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
    final groupChoices = [
      "Competitiesectie",
      "Wedstrijdsectie",
      "Club8+",
      "TopC4+",
      "Sjaarzen",
    ]; // TODO: This list should include all groups available.
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
