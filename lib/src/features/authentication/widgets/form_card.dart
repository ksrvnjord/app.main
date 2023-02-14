import 'package:flutter/material.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/rounded_elevated_button.dart';
import 'package:routemaster/routemaster.dart';
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
    // TODO: Implement in Heimdall
    // return const ForgotForm();
    const double textPadding = 16;

    const double buttonHeight = 54;
    const double buttonPadding = 16;
    const double cardElevation = 8;
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
          color: Colors.lightBlue,
          child: Text(buttonText),
        ).height(buttonHeight).padding(right: buttonPadding).expanded(),
        RoundedElevatedButton(
          child: const Icon(Icons.arrow_back),
          onPressed: () => Routemaster.of(context).pop(),
        ).height(buttonHeight),
      ].toRow(),
    ]
        .toColumn()
        .padding(all: cardInnerPadding)
        .card(
          elevation: cardElevation,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(40)),
          ),
        )
        .padding(all: cardOuterPadding)
        .alignment(Alignment.center);
  }
}
