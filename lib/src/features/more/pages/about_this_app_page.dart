// Create a generic page which will be used to display details about the app version and build number.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ksrvnjord_main_app/src/features/more/providers/package_info_provider.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/data_text_list_tile.dart';
import 'package:styled_widget/styled_widget.dart';

class AboutThisAppPage extends ConsumerWidget {
  const AboutThisAppPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Over deze app'),
      ),
      body: ListView(
        children: [
          ref.watch(packageInfoProvider).when(
                data: (data) => [
                  DataTextListTile(
                    name: "Versie",
                    value: data.version,
                  ),
                  // Buildnumber in DataTextListTile is not a typo.
                  DataTextListTile(
                    name: "Buildnummer",
                    value: data.buildNumber,
                  ),
                ].toColumn(),
                error: (error, stackTrace) => Text(error.toString()),
                loading: () => const CircularProgressIndicator(),
              ),
          const DataTextListTile(
            name: "Met liefde gemaakt door",
            value: "de Appcommissie",
          ),
        ],
      ),
    );
  }
}
