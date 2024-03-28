import 'package:flutter/material.dart';
import 'package:styled_widget/styled_widget.dart';

class AnswerNotCompletedWarningCard extends StatelessWidget {
  const AnswerNotCompletedWarningCard({
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
        ? isCompleted
            ? Icon(Icons.dangerous, size: 20, color: colorScheme.error)
            : Icon(Icons.dangerous, size: 20, color: colorScheme.error)
        : const SizedBox.shrink();
  }
}
