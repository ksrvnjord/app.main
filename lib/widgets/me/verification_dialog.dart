import 'package:flutter/material.dart';

void verificationDialog(context, querySucces) {
  Map<String, dynamic> verificationSettings = {};
  if (querySucces == false) {
    verificationSettings['title'] = 'Aanvraag Mislukt!\n\n';
    verificationSettings['body'] =
        '''Weet je zeker dat je in elk gewijzigd veld (blauw)
                    een geldige waarde hebt opgegeven?''';
    verificationSettings['color'] = Colors.red;
  } else {
    verificationSettings['title'] = 'Aanvraag Geslaagd!\n\n';
    verificationSettings['body'] =
        '''Het even duren voordat de wijzigingen in de almanak
                  zichtbaar zijn!''';
    verificationSettings['color'] = Colors.green;
  }
  showDialog(
      barrierDismissible: true,
      barrierColor: null,
      context: context,
      builder: (BuildContext context) =>
          VerificationDialog(verificationSettings));
}

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
