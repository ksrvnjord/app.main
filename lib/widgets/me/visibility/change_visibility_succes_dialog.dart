import 'package:flutter/material.dart';
import 'package:ksrvnjord_main_app/widgets/me/verification_dialog.dart';

void changeVisibilitySuccesDialog(context, querySucces) {
  Map<String, dynamic> verificationSettings = {};
  if (querySucces == false) {
    verificationSettings['title'] = 'Aanvraag Mislukt!\n\n';
    verificationSettings['body'] =
        '''Neem contact op met de Appcommissie als je denkt dat dit niet klopt.''';
    verificationSettings['color'] = Colors.red;
  } else {
    verificationSettings['title'] = 'Aanvraag Geslaagd!\n\n';
    verificationSettings['body'] =
        '''Wijzigingen zouden direct zichtbaar moeten zijn in de almanak.''';
    verificationSettings['color'] = Colors.green;
  }

  showDialog(
      barrierDismissible: true,
      barrierColor: null,
      context: context,
      builder: (BuildContext context) =>
          VerificationDialog(verificationSettings));
}
