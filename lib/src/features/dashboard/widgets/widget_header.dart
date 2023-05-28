import 'package:flutter/material.dart';
import 'package:styled_widget/styled_widget.dart';

class WidgetHeader extends StatelessWidget {
  const WidgetHeader({
    Key? key,
    required this.title,
    this.onTapName,
    this.onTap,
  }) : super(key: key);

  final String title;
  final String? onTapName;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return [
      Text(
        title,
        style: textTheme.headlineSmall,
      ).alignment(Alignment.centerLeft),
      if (onTap != null)
        GestureDetector(
          // ignore: sort_child_properties_last
          child: [
            if (onTapName != null)
              Text(
                onTapName ?? "",
                style: textTheme.labelLarge,
              ),
            const Icon(
              Icons.arrow_forward_ios,
              size: 16,
            ),
          ].toRow(mainAxisAlignment: MainAxisAlignment.end),
          onTap: onTap,
        ).alignment(Alignment.centerRight),
    ].toStack(
      alignment: Alignment.center,
    );
  }
}
