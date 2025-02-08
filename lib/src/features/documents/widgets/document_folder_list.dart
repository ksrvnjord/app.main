import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ksrvnjord_main_app/src/features/documents/widgets/document_file_button.dart';
import 'package:ksrvnjord_main_app/src/features/documents/widgets/document_folder_button.dart';

// De announcement laden niet juist in krijg een png icon te zien en kan er niet op klikken.
// Misschien alles naar .jpg veranderen?

class DocumentFolderList extends ConsumerWidget {
  const DocumentFolderList({
    super.key,
    required this.listResult,
  });

  final ListResult listResult;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Copy the lists, so we can modify it in-build.
    final prefixes = listResult.prefixes.toList();
    final items = listResult.items.toList();

    // Remove the sacred "thumbnails" folder.
    prefixes.retainWhere(
      (e) => !e.fullPath.contains('thumbnails'),
    );

    // Sort everything name (currently prefixed by date) descending.
    prefixes.sort((a, b) => -1 * a.name.compareTo(b.name));
    items.sort((a, b) => -1 * a.name.compareTo(b.name));

    const crossAxisCount = 2;

    const double gridAspectRatio = 1 /
        0.7; // The iPhone 14 Pro aspect ratio, considering the amount of items in cross-axis.

    // Return navigation items for the folder (reversed for descending order).
    const double mainAxisSpacing = 32;

    return GridView.count(
      padding: const EdgeInsets.all(8),
      crossAxisCount: crossAxisCount,
      mainAxisSpacing: mainAxisSpacing,
      childAspectRatio: gridAspectRatio,
      children: [
        ...prefixes.map((e) => DocumentFolderButton(item: e)),
        ...items.map((e) => DocumentFileButton(item: e)),
      ],
    );
  }
}
