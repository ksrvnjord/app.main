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
          color: Colors.grey,
          fontWeight: FontWeight.w300,
          fontSize: 16,
        ),
      ),
      subtitle: Wrap(
        spacing: permissionChipSpacing,
        children: values
            .map((permission) => Chip(
                  label: Text(
                    permission,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.normal,
                      fontSize: 16,
                    ),
                  ),
                  backgroundColor: () {
                    if (colors != null && colors!.containsKey(permission)) {
                      return colors![permission];
                    } else {
                      return Colors.grey;
                    }
                  }(),
                ))
            .toList(),
      ),
    );
  }
}
