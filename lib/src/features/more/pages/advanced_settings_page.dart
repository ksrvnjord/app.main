import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ksrvnjord_main_app/src/features/shared/model/hive_cache.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:styled_widget/styled_widget.dart';

class AdvancedSettingsPage extends StatelessWidget {
  const AdvancedSettingsPage({super.key});

  // Create  a function that clear the cache and exits the app.
  Future<void> clearAppData() async {
    await HiveCache.deleteAll();
    final prefs = await SharedPreferences.getInstance();
    // ignore: avoid-ignoring-return-values
    await prefs.clear();

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
      ),
      body: ListView(children: [
        // Create a button to clear the cache.
        ListTile(
          title: const Text('Cache verwijderen'),
          subtitle: const Text(
            "Alle opgeslagen data op je telefoon wordt verwijderd. Dit sluit je app af.",
          ),
          trailing: const Icon(Icons.delete_outline, color: Colors.red),
          visualDensity: VisualDensity.standard,
          onTap: () => showDialog(
            context: context,
            builder: (BuildContext context) => AlertDialog(
              title: const Text('Cache verwijderen'),
              content: const Text(
                'Weet je zeker dat je alle opgeslagen data op je telefoon wilt verwijderen en de app wil afsluiten?',
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Annuleren'),
                ),
                TextButton(
                  onPressed: () => clearAppData(),
                  child: const Text('Verwijder de cache en sluit mijn app af')
                      .textColor(Colors.red),
                ),
              ],
            ),
          ),
        ),
      ]),
    );
  }
}
