import 'package:flutter/material.dart';
import 'package:ksrvnjord_main_app/assets/images.dart';

class ErrorCardWidget extends StatelessWidget {
  const ErrorCardWidget(this.errorMessage, {Key? key}) : super(key: key);

  final String errorMessage;

  @override
  Widget build(BuildContext context) {
    final Color errorColor = Colors.red.shade800;
    return GestureDetector(
      onTap: () {
        const AlertDialog ad = AlertDialog(
          content: Text("Dingen vragen hiero")
        );

        showDialog(context: context, builder: (BuildContext context) {
          return ad;
        });
      },
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
              side: BorderSide(color: errorColor, width: 2),
              borderRadius: BorderRadius.circular(10)),
        clipBehavior: Clip.antiAlias,
        child: Row(
          // crossAxisAlignment: CrossAxisAlignment.stretch, // This crashes
          children: [
            Expanded(
              flex: 3,  // Use 30% of available width
              child: Padding(
                padding: const EdgeInsets.all(0),
                child: Image.asset(Images.deadSwan),
                // ClipRRect(
                //   borderRadius: const BorderRadius.all(Radius.circular(5)),
                //   child: Image.asset(Images.deadSwan),
                // ),
              )
            ),
            Expanded(
              flex: 7,
              child: Column(
                children: [
                  Text(
                    "Er is iets misgegaan",
                    style: TextStyle(color: errorColor, fontSize: 18),
                  ),
                  Text(
                    "Melding: " + errorMessage,
                    style: const TextStyle(fontSize: 14),
                  ),
                  const Text(
                    "Verzend een foutrapport door op deez te klikken",
                    style: TextStyle(fontSize: 10),
                  )
                ],
              )
            )
          ],
        )
      )
    );
  }
}