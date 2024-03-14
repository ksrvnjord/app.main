import 'package:flutter/material.dart';
import 'package:styled_widget/styled_widget.dart';

class AnswerStatusCard extends StatelessWidget {
  const AnswerStatusCard({
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

    return answerExists
        ? Card(
            color: isCompleted
                ? colorScheme.primaryContainer
                : colorScheme.secondaryContainer,
            elevation: 0,
            margin: EdgeInsets.zero,
            child: Text(
              isCompleted ? "Ingevuld" : "Onvolledig Ingevuld",
              style: textStyle,
            ).padding(horizontal: horizontalPadding, vertical: verticalPadding),
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
