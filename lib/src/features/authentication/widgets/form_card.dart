import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/rounded_elevated_button.dart';
import 'package:styled_widget/styled_widget.dart';

class FormCard extends StatelessWidget {
  const FormCard({
    Key? key,
    required this.explanation,
    required this.buttonText,
    required this.onPressed,
  }) : super(key: key);

  final String explanation;
  final String buttonText;
  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    // TODO: Implement in Heimdall.

    const double textPadding = 16;

    const double buttonHeight = 54;
    const double buttonPadding = 16;
    const double cardOuterPadding = 16;
    const double cardInnerPadding = 24;
    const double textSize = 16;

    return [
      Text(
        explanation,
        textAlign: TextAlign.center,
      ).fontSize(textSize).padding(vertical: textPadding),
      [
        RoundedElevatedButton(
          onPressed: onPressed,
          child: Text(buttonText),
        ).height(buttonHeight).padding(right: buttonPadding).expanded(),
        RoundedElevatedButton(
          onPressed: () => context.goNamed('Login'),
          child: const Icon(Icons.arrow_back),
        ).height(buttonHeight),
      ].toRow(),
    ]
        .toColumn()
        .padding(all: cardInnerPadding)
        .card(
          elevation: 0,
          shape: RoundedRectangleBorder(
            side: BorderSide(
              color: Theme.of(context).colorScheme.outline,
            ),
            borderRadius: const BorderRadius.all(Radius.circular(12)),
          ),
        )
        .padding(all: cardOuterPadding)
        .alignment(Alignment.center);
  }
}
