import 'package:flutter/material.dart';

class SelectGroupWidget extends StatelessWidget {
  const SelectGroupWidget({
    required this.initialValue,
    required this.onChanged,
    this.groupsSelected,
    Key? key,
  }) : super(key: key);

  final String? initialValue;
  final void Function(String?, bool?) onChanged;
  final Map<String, bool>? groupsSelected;

  @override
  Widget build(BuildContext context) {
    // final groupsSelected = {
    //   "Competitiesectie": false,
    //   "Wedstrijdsectie": true,
    // };

    return Column(
      children: (groupsSelected ?? {"Test": false})
          .entries
          .map((group) => CheckboxListTile(
                value: group.value,
                onChanged: ((bool? value) => {
                      // ((String? group.key, bool? value) => onChanged(group.key, value)),.
                      if (value ?? true)
                        {onChanged(group.key, value)}
                      else
                        {onChanged(null, value)},
                    }),
                title: Text(group.key),
              ))
          .toList(),
    );
  }
}
