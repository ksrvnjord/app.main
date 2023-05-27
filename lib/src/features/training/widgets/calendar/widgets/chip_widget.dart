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
        style: Theme.of(context).textTheme.labelLarge,
      ),
      subtitle: Wrap(
        spacing: permissionChipSpacing,
        children: values
            .map((permission) => Chip(
                  label: Text(
                    permission,
                  ),
                  backgroundColor: () {
                    return colors != null &&
                            (colors as Map<String, Color>)
                                .containsKey(permission)
                        ? (colors as Map<String, Color>)[permission]
                        : null;
                  }(),
                ))
            .toList(),
      ),
    );
  }
}
