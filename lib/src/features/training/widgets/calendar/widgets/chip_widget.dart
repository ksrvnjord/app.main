import 'package:flutter/material.dart';

class ChipWidget extends StatelessWidget {
  const ChipWidget({
    super.key,
    required this.title,
    required this.values,
    this.colors,
  });

  final Map<String, Color>? colors;

  final String title;
  final List<String> values;

  @override
  Widget build(BuildContext context) {
    const double permissionChipSpacing = 4;

    return ListTile(
      title: Text(
        title,
        style: const TextStyle(
            color: Colors.grey, fontSize: 16, fontWeight: FontWeight.w300),
      ),
      subtitle: Wrap(
        spacing: permissionChipSpacing,
        children: values
            .map((permission) => Chip(
                  label: Text(
                    permission,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.normal),
                  ),
                  backgroundColor: () {
                    return colors != null && colors!.containsKey(permission)
                        ? colors![permission]
                        : Colors.grey;
                  }(),
                ))
            .toList(),
      ),
    );
  }
}
