import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ksrvnjord_main_app/src/features/shared/model/hive_cached_image.dart';
import 'package:styled_widget/styled_widget.dart';

class AdvancedSettingsPage extends StatelessWidget {
  const AdvancedSettingsPage({Key? key}) : super(key: key);

  // create  a function that clear the cache and exits the app
  Future<void> clearCache() async {
    await deleteAllCache();
    if (Platform.isAndroid) {
      SystemNavigator.pop();
    } else if (Platform.isIOS) {
      exit(0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Geavanceerde instellingen'),
        backgroundColor: Colors.lightBlue,
        shadowColor: Colors.transparent,
      ),
      body: ListView(children: [
        // create a button to clear the cache
        ListTile(
          title: const Text('Cache verwijderen'),
          subtitle: const Text(
            "Alle opgeslagen data op je telefoon wordt verwijderd. Dit sluit je app af.",
          ),
          trailing: const Icon(Icons.delete_outline, color: Colors.red),
          onTap: () => // show dialog
              showDialog(
            context: context,
            builder: (BuildContext context) => AlertDialog(
              title: const Text('Cache verwijderen'),
              content: const Text(
                'Weet je zeker dat je alle opgeslagen data op je telefoon wilt verwijderen en de app wil afsluiten?',
              ),
              actions: [
                TextButton(
                  child: const Text('Annuleren').textColor(Colors.lightBlue),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                TextButton(
                  child: const Text('Verwijder de cache en sluit mijn app af')
                      .textColor(Colors.red),
                  onPressed: () => clearCache(),
                ),
              ],
            ),
          ),
        ),
        const Divider(),
      ]),
    );
  }
}
