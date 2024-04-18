import 'package:flutter/material.dart';

// class SelectGroupWidget extends StatefulWidget {
//   const SelectGroupWidget({
//     // Required this.initialValue,.
//     // required this.onChanged,
//     this.groupsSelected,
//     this.groups = const [],
//     Key? key,
//   }) : super(key: key);

//   // Final String? initialValue;.
//   // final void Function(String?, bool?) onChanged;
//   final Map<String, bool>? groupsSelected;
//   final List<String> groups;

//   @override
//   createState() => _SelectGroupWidgetState();
// }

class SelectGroupWidget extends StatelessWidget {
  const SelectGroupWidget({
    // Required this.initialValue,.
    // required this.onChanged,
    this.groupsSelected,
    this.groups = const [],
    Key? key,
  }) : super(key: key);

  // Final String? initialValue;.
  // final void Function(String?, bool?) onChanged;
  final Map<String, bool>? groupsSelected;
  final List<String> groups;
  @override
  Widget build(BuildContext context) {
    final groupChoices = ["Competitiesectie", "Wedstrijdsectie", "Club8+"];
    // final groupsSelected = {
    //   "Competitiesectie": false,
    //   "Wedstrijdsectie": true,
    // };

    // return Column(
    //   children: (groupsSelected ?? {"Test": false})
    //       .entries
    //       .map((group) => CheckboxListTile(
    //             value: group.value,
    //             onChanged: ((bool? value) => {
    //                   // ((String? group.key, bool? value) => onChanged(group.key, value)),.
    //                   if (value ?? true)
    //                     {onChanged(group.key, value)}
    //                   else
    //                     {onChanged(null, value)},
    //                 }),
    //             title: Text(group.key),
    //           ))
    //       .toList(),
    // );

    return Column(
      children: groupChoices
          .map((group) => CheckboxListTile(
                value: groups.contains(group),
                onChanged: ((bool? value) => {
                      if (value ?? false) {groups.add(group)},
                      if (!(value ?? true) && groups.contains(group))
                        {groups.remove(group)},
                    }),
                title: Text(group),
              ))
          .toList(),
    );
  }
}
