import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/edit_my_profile/widgets/form_section.dart';
import 'package:ksrvnjord_main_app/src/features/shared/providers/theme_brightness_notifier.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:flutter/services.dart';
import 'package:ksrvnjord_main_app/src/features/shared/model/hive_cache.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ksrvnjord_main_app/src/features/authentication/model/auth_controller.dart';
import 'dart:io';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

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
  Widget build(BuildContext context, WidgetRef ref) {
    const double groupSpacing = 32;

    final themeBrightness = ref.watch(themeBrightnessProvider);
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('App-Instellingen'),
      ),
      body: ListView(
        padding: const EdgeInsets.only(left: 8, top: 8, right: 8, bottom: 80),
        children: [
          [
            FormSection(title: "Instellingen", children: [
              ListTile(
                title: const Text('Wijzig mijn zichtbaarheid in de app'),
                trailing: const Icon(
                  Icons.arrow_forward_ios,
                ),
                onTap: () => context.goNamed('Edit My Visibility'),
              ),
              ListTile(
                title: const Text('Stel mijn notificatievoorkeuren in'),
                trailing: const Icon(
                  Icons.arrow_forward_ios,
                ),
                onTap: () => context.goNamed(
                  'Notification Preferences',
                ),
              ),
              SizedBox(
                  width: 324,
                  child: DropdownButtonFormField<ThemeMode>(
                    items: ThemeMode.values
                        .map((mode) => DropdownMenuItem(
                              value: mode,
                              child: Text(
                                {
                                      ThemeMode.system:
                                          'Gebruik telefooninstellingen',
                                      ThemeMode.light: 'Licht',
                                      ThemeMode.dark: 'Donker',
                                    }[mode] ??
                                    'Onbekend',
                              ),
                            ))
                        .toList(),
                    value: themeBrightness.when(
                      data: (brightness) => brightness,
                      loading: () => ThemeMode.system,
                      error: (error, stackTrace) => ThemeMode.system,
                    ),
                    hint: const Text('Weergave modus'),
                    onChanged: (value) => ref
                        .read(themeBrightnessProvider.notifier)
                        .setThemeMode(value),
                    isExpanded: true,
                    decoration:
                        const InputDecoration(labelText: 'Weergave modus'),
                  )),
              ListTile(
                title: const Text("Over deze app"),
                trailing: const Icon(
                  Icons.arrow_forward_ios,
                ),
                onTap: () => context.goNamed(
                  "About this app",
                ),
              ),
              ListTile(
                title: const Text("Bekijk het Privacy Beleid"),
                trailing: const Icon(
                  Icons.arrow_forward_ios,
                ),
                onTap: () => context.goNamed(
                  "Settings -> Privacy Beleid",
                ),
              ),
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
                        child: const Text(
                                'Verwijder de cache en sluit mijn app af')
                            .textColor(Colors.red),
                      ),
                    ],
                  ),
                ),
              ),
              ListTile(
                title: Text('Uitloggen', style: textTheme.titleMedium)
                    .textColor(colorScheme.error),
                trailing: Icon(Icons.logout, color: colorScheme.error),
                visualDensity: VisualDensity.standard,
                onTap: () => ref.read(authControllerProvider.notifier).logout(),
              ),
            ]),
          ].toColumn(
            separator: const SizedBox(height: groupSpacing),
          ),
        ],
      ),
    );
  }
}
