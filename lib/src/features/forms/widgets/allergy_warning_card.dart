import 'package:flutter/material.dart';
import 'package:styled_widget/styled_widget.dart';

class AllergyWarningCard extends StatelessWidget {
  const AllergyWarningCard({super.key, this.sidePadding = 0.0});

  final double sidePadding;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final iconSize = 16.0;
    final bottomPadding = 16.0;
    final hPadding = 16.0;
    final vPadding = 8.0;

    return Card(
      color: colorScheme.errorContainer,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
      ),
      margin: const EdgeInsets.all(0.0),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: vPadding, horizontal: hPadding),
        child: Row(children: [
          Icon(
            Icons.warning_amber,
            size: iconSize,
          ),
          SizedBox(width: hPadding),
          Expanded(
            child: Text(
              "Allergieën? Help de KoCo door ze hier aan te geven.",
              style: textTheme.bodyMedium,
            ),
          ),
          Icon(
            Icons.arrow_forward_ios,
            size: iconSize,
          ),
        ]),
      ),
    ).padding(
      bottom: bottomPadding,
      horizontal: sidePadding,
    );
  }
}
