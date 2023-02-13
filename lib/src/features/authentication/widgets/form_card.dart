import 'package:flutter/material.dart';
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
        ElevatedButton(
          onPressed: onPressed,
          child: Text(buttonText).fontSize(textSize),
        ).height(buttonHeight).padding(right: buttonPadding).expanded(),
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: Colors.blueGrey),
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
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
        )
        .padding(all: cardOuterPadding)
        .alignment(Alignment.center);
  }
}
