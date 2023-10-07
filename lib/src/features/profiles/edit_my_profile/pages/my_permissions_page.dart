import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/edit_my_profile/api/my_permissions_provider.dart';
import 'package:ksrvnjord_main_app/src/features/training/widgets/calendar/widgets/chip_widget.dart';
import 'package:styled_widget/styled_widget.dart';

class MyPermissionsPage extends ConsumerWidget {
  const MyPermissionsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final val = ref.watch(myPermissionsProvider);

    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mijn permissies'),
      ),
      body: ListView(
        children: [
          MaterialBanner(
            content: const Text(
              "Staan jouw permissies niet goed? Neem dan contact op met de wedstrijd/competitie commissaris.",
            ),
            actions: const [SizedBox.shrink()],
            leading: const Icon(Icons.question_mark),
            backgroundColor: colorScheme.primaryContainer,
          ),
          MaterialBanner(
            content: const Text(
              "Zijn jouw permissies recentelijk aangepast? Dan kan het zijn dat je moet uitloggen en opnieuw inloggen om de wijzigingen te zien.",
            ),
            actions: const [SizedBox.shrink()],
            leading: const Icon(Icons.info_outline),
            backgroundColor: colorScheme.tertiaryContainer,
          ),
          const SizedBox(height: 16),
          val.when(
            data: (permissions) => permissions.isEmpty
                ? const Text('Je hebt geen afschrijfpermissies').center()
                : ChipWidget(values: permissions),
            error: (error, stack) => Text(error.toString()),
            loading: () => const CircularProgressIndicator.adaptive().center(),
          ),
        ],
      ),
    );
  }
}
