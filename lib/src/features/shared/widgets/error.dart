import 'package:flutter/material.dart';
import 'package:ksrvnjord_main_app/assets/images.dart';

class ErrorCardWidget extends StatelessWidget {
  const ErrorCardWidget({
    Key? key,
    required this.errorMessage,
  }) : super(key: key);

  final String errorMessage;

  @override
  Widget build(BuildContext context) {
    final Color errorColor = Colors.red.shade800;
    const double errorCardHeight = 100;
    const double errorTitleFontSize = 18;
    const double cardBorderWidth = 2;

    return GestureDetector(
      child: Container(
        height: errorCardHeight,
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        decoration: BoxDecoration(
          border: Border.all(width: cardBorderWidth, color: errorColor),
          borderRadius: const BorderRadius.all(Radius.circular(10)),
        ),
        clipBehavior: Clip.antiAlias,
        child: Row(children: [
          Expanded(
            flex: 0,
            child: Image.asset(Images.deadSwan),
          ),
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                // crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Er is iets misgegaan",
                    style: TextStyle(
                      color: errorColor,
                      fontSize: errorTitleFontSize,
                    ),
                  ),
                  Expanded(
                    child: Container(
                      alignment: Alignment.center,
                      child: Text(
                        "Melding: $errorMessage",
                        style: const TextStyle(fontSize: 14),
                      ),
                    ),
                  ),
                  // const Expanded(
                  //   flex: 1,
                  //   child: Text(
                  //     "Tik hier om een foutrapport te verzenden",
                  //     style: TextStyle(fontSize: 10),
                  //   )
                  // )
                ],
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
