import 'package:flutter/material.dart';
import 'package:styled_widget/styled_widget.dart';

class AnswerStatusCardThumbnail extends StatelessWidget {
  const AnswerStatusCardThumbnail({
    Key? key,
    required this.answerExists,
    required this.isCompleted,
    this.textStyle,
  }) : super(key: key);

  final bool answerExists;
  final bool isCompleted;
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
                  isCompleted ? "Ingevuld" : "Niet Verzonden!",
                  style: textStyle,
                ).padding(
                  horizontal: horizontalPadding,
                  vertical: verticalPadding,
                ),
              ),
              if (!isCompleted)
                Icon(
                  Icons.warning_rounded,
                  size: iconSize,
                  color: colorScheme.error,
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
