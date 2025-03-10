import 'package:flutter/material.dart';
import 'package:styled_widget/styled_widget.dart';

class WidgetHeader extends StatelessWidget {
  /// This widget is used to display a header with a title and an optional
  /// clickable text.
  /// The [title] is the main text of the header.
  /// The [onTapName] is the optional clickable text.
  /// The [onTap] is the callback when the [onTapName] is clicked.
  /// Note: Place this widget only in full-width containers, as this widget is already padded.
  const WidgetHeader({
    super.key,
    required this.title,
    required this.titleIcon,
    this.onTapName,
    this.onTap,
  });

  final String title;
  final String? onTapName;
  final VoidCallback? onTap;
  final IconData titleIcon;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    const double headerHPadding = 8;

    final labelStyle = textTheme.labelLarge;

    return [
      [
        Icon(
          titleIcon,
          size: textTheme.titleLarge?.fontSize,
          color: colorScheme.primary,
        ),
        Text(
          title,
          style: textTheme.titleLarge,
        ).alignment(Alignment.centerLeft),
      ].toRow(
        separator: const SizedBox(width: 8),
      ),
      if (onTap != null)
        GestureDetector(
          // ignore: sort_child_properties_last
          child: onTapName == null
              ? const SizedBox.shrink()
              : [
                  Text(
                    onTapName ?? "",
                    style: labelStyle?.copyWith(
                      color: colorScheme.secondary,
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    // ignore: no-magic-number
                    size: labelStyle?.fontSize,
                    color: colorScheme.secondary,
                  ),
                ].toRow(mainAxisAlignment: MainAxisAlignment.end),
          onTap: onTap,
        ).alignment(Alignment.centerRight),
    ]
        .toStack(
          alignment: Alignment.center,
        )
        .padding(horizontal: headerHPadding);
  }
}
