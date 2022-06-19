import 'package:flutter/material.dart';

class VerificationDialog extends StatelessWidget {
  const VerificationDialog(this.verificationSettings, {Key? key})
      : super(key: key);

  final Map verificationSettings;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        backgroundColor: verificationSettings['color'],
        alignment: Alignment.bottomCenter,
        insetPadding: const EdgeInsets.all(10),
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
                      text: verificationSettings['title'],
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.black)),
                  TextSpan(
                      text: verificationSettings['body'],
                      style: const TextStyle(color: Colors.black, fontSize: 15))
                ]))
          ],
        ));
  }
}
