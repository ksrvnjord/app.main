import 'package:flutter/material.dart';
import 'package:styled_widget/styled_widget.dart';

class AnswerStatusCard extends StatelessWidget {
  const AnswerStatusCard({
    super.key,
    required this.answerExists,
    required this.isCompleted,
    required this.showIcon,
    this.textStyle,
  });

  final bool answerExists;
  final bool isCompleted;
  final bool showIcon;
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    const horizontalPadding = 8.0;

    const verticalPadding = 2.0;

    const iconSize = 32.0;

    return answerExists
        ? Row(
            children: [
              Card(
                color: isCompleted
                    ? colorScheme.primaryContainer
                    : colorScheme.errorContainer, // Was secondaryContainer.
                elevation: 0,
                margin: EdgeInsets.zero,
                child: Text(
                  isCompleted ? "Verzonden" : "Niet Verzonden",
                  style: textStyle,
                ).padding(
                  horizontal: horizontalPadding,
                  vertical: verticalPadding,
                ),
              ),
              if (!isCompleted && showIcon)
                Icon(
                  Icons.warning_rounded,
                  size: iconSize,
                  color: colorScheme.errorContainer,
                ),
            ],
          )
        : Card(
            color: colorScheme.tertiaryContainer,
            elevation: 0,
            margin: EdgeInsets.zero,
            child: Text("Niet ingevuld", style: textStyle).padding(
              horizontal: horizontalPadding,
              vertical: verticalPadding,
            ),
          );
  }
}
