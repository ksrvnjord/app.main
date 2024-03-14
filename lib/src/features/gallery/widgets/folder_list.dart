import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ksrvnjord_main_app/src/features/gallery/utils/gallery_view_provider.dart';
import 'package:ksrvnjord_main_app/src/features/gallery/widgets/file_button.dart';
import 'package:ksrvnjord_main_app/src/features/gallery/widgets/folder_button.dart';

class FolderList extends ConsumerStatefulWidget {
  const FolderList({Key? key, required this.listResult}) : super(key: key);
  final ListResult listResult;

  @override
  createState() => _FolderListState();
}

class _FolderListState extends ConsumerState<FolderList> {
  @override
  Widget build(BuildContext context) {
    final gridOrList = ref.watch(gridOrListViewProvider);
    final prefixes = widget.listResult.prefixes.toList();
    final items = widget.listResult.items.toList();

    // Remove the sacred "thumbnails" folder.
    prefixes.retainWhere((e) => !e.fullPath.contains('thumbnails'));

    // Sort everything name (currently prefixed by date) descending.
    prefixes.sort((a, b) => -1 * a.name.compareTo(b.name));
    items.sort((a, b) => -1 * a.name.compareTo(b.name));

    int crossAxisCount = 3;
    double childAspect = 1.0;
    const itemSpacing = 8.0;

    if (gridOrList) {
      crossAxisCount = 1;
      const num = 1.5;
      childAspect = num;
    }

    return GridView.count(
      padding: const EdgeInsets.all(8),
      crossAxisCount: crossAxisCount,
      mainAxisSpacing: itemSpacing,
      // ignore: no-equal-arguments
      crossAxisSpacing: itemSpacing,
      childAspectRatio: childAspect,
      children: [
        ...prefixes.map((e) => FolderButton(item: e)),
        ...items.map((e) => FileButton(item: e)),
      ],
    );
  }
}
