import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ksrvnjord_main_app/src/features/gallery/widgets/file_button.dart';
import 'package:ksrvnjord_main_app/src/features/gallery/widgets/folder_button.dart';

const crossAxisCount = 4;

class FolderList extends ConsumerWidget {
  final ListResult listResult;

  const FolderList({
    Key? key,
    required this.listResult,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Copy the lists, so we can modify it in-build
    var prefixes = listResult.prefixes.toList();
    var items = listResult.items.toList();

    // Remove the sacred "thumbnails" folder
    prefixes.retainWhere(
      (e) => !e.fullPath.contains('thumbnails'),
    );

    // Sort everything name (currently prefixed by date) descending
    prefixes.sort((a, b) => -1 * a.name.compareTo(b.name));
    items.sort((a, b) => -1 * a.name.compareTo(b.name));

    // Return navigation items for the folder (reversed for descending order)
    return GridView.count(
      crossAxisCount: crossAxisCount,
      children: [
        ...prefixes.map((e) => FolderButton(item: e)),
        ...items.map((e) => FileButton(item: e)),
      ],
    );
  }
}
