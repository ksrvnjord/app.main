import 'package:flutter/material.dart';

class VerificationDialog extends StatelessWidget {
  const VerificationDialog(this.title, this.body, {Key? key}) : super(key: key);

  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        backgroundColor: Colors.green,
        alignment: Alignment.bottomCenter,
        insetPadding: const EdgeInsets.all(0),
        contentPadding: const EdgeInsets.all(10),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.all(0),
                child: IconButton(
                    padding: const EdgeInsets.only(bottom: 5),
                    constraints: BoxConstraints.tight(const Size(20, 20)),
                    iconSize: 20,
                    icon: const Icon(Icons.close_rounded, color: Colors.black),
                    onPressed: () {
                      Navigator.pop(context);
                    })),
            RichText(
                textAlign: TextAlign.center,
                text: TextSpan(children: <TextSpan>[
                  TextSpan(
                      text: title,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.black)),
                  TextSpan(
                      text: body,
                      style: const TextStyle(color: Colors.black, fontSize: 16))
                ]))
          ],
        ));
  }
}
