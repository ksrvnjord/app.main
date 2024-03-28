import 'package:flutter/material.dart';

class SelectGroupWidget extends StatelessWidget {
  SelectGroupWidget({
    required this.initialValue,
    required this.onChanged,
    Key? key,
  }) : super(key: key);

  final String? initialValue;
  final void Function(String?) onChanged;
  bool? _isSelected = false;

  @override
  Widget build(BuildContext context) {
    final groupsSelected = {
      "Competitiesectie": false,
      "Wedstrijdsectie": true,
    };

    return Column(
      children: groupsSelected.entries
          .map((group) => CheckboxListTile(
                value: group.value,
                onChanged: ((bool? value) => _isSelected = value),
                title: Text(group.key),
              ))
          .toList(),
    );
  }
}
