import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/edit_my_profile/widgets/form_section.dart';
import 'package:ksrvnjord_main_app/src/features/shared/providers/theme_brightness_notifier.dart';
import 'package:ksrvnjord_main_app/src/routes/routes.dart';
import 'package:styled_widget/styled_widget.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const double groupSpacing = 32;

    final themeBrightness = ref.watch(themeBrightnessProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Instellingen'),
      ),
      body: ListView(
        padding: const EdgeInsets.only(left: 8, top: 8, right: 8, bottom: 80),
        children: [
          [
            // ignore: avoid-non-ascii-symbols
            FormSection(title: "🕵️ Privacy", children: [
              ListTile(
                title: const Text('Wijzig mijn zichtbaarheid in de app'),
                trailing: const Icon(
                  Icons.arrow_forward_ios,
                ),
                onTap: () => context.goNamed(
                  'Edit My Visibility',
                ), // In de toekomst willen we niet alleen dat ploegen worden weergegeven, maar ook commissies en andere groepen.
              ),
            ]),
            // ignore: avoid-non-ascii-symbols
            FormSection(title: "🔔 Notificaties", children: [
              ListTile(
                title: const Text('Stel mijn notificatievoorkeuren in'),
                trailing: const Icon(
                  Icons.arrow_forward_ios,
                ),
                onTap: () => context.goNamed(
                  'Notification Preferences',
                ), // In de toekomst willen we niet alleen dat ploegen worden weergegeven, maar ook commissies en andere groepen.
              ),
            ]),
            // ignore: avoid-non-ascii-symbols
            FormSection(title: "🔆 Weergave", children: [
              DropdownButtonFormField<ThemeMode>(
                items: ThemeMode.values
                    .map((mode) => DropdownMenuItem(
                          value: mode,
                          child: Text(
                            {
                                  ThemeMode.system:
                                      'Gebruik telefooninstellingen',
                                  ThemeMode.light: 'Licht',
                                  ThemeMode.dark: 'Lustrum',
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
                decoration: const InputDecoration(labelText: 'Weergave modus'),
              ),
            ]),
            // ignore: avoid-non-ascii-symbols
            FormSection(title: "⚙️ Geavanceerde instellingen", children: [
              ListTile(
                title: const Text('Geavanceerde instellingen'),
                trailing: const Icon(
                  Icons.arrow_forward_ios,
                ),
                onTap: () => context.goNamed(
                  'Advanced Settings',
                ), // In de toekomst willen we niet alleen dat ploegen worden weergegeven, maar ook commissies en andere groepen.
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
