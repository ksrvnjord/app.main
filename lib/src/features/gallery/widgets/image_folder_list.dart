import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:collection/collection.dart';
import 'package:ksrvnjord_main_app/src/features/gallery/utils/gallery_view_provider.dart';
import 'package:ksrvnjord_main_app/src/features/gallery/widgets/image_file_button.dart';
import 'package:ksrvnjord_main_app/src/features/gallery/widgets/image_folder_button.dart';

/// This widget displays a grid of images or folders with images in it.
/// Changes made to this widget should also be reflected in [AnnouncementFolderList].
/// Because that file closely resembles this one. Apart from minor changes.

class ImageFolderList extends ConsumerStatefulWidget {
  const ImageFolderList({super.key, required this.listResult});
  final ListResult listResult;

  @override
  createState() => _FolderListState();
}

class _FolderListState extends ConsumerState<ImageFolderList> {
  @override
  Widget build(BuildContext context) {
    final gridOrList = ref.watch(gridOrListViewProvider);
    final prefixes = widget.listResult.prefixes.toList();
    var items = widget.listResult.items.toList();

    // Remove the sacred "thumbnails" folder.
    prefixes.retainWhere((e) => !e.fullPath.contains('thumbnails'));

    int crossAxisCount = 3;
    double childAspect = 1.0;
    const itemSpacing = 8.0;

    if (gridOrList) {
      crossAxisCount = 1;
      const num = 1.5;
      childAspect = num;
    }

    // Sort everything name (currently prefixed by date) descending.
    prefixes.sort((a, b) => -1 * a.name.compareTo(b.name));
    items.sort((a, b) => -1 * a.name.compareTo(b.name));

    return GridView.count(
      padding: const EdgeInsets.all(8),
      crossAxisCount: crossAxisCount,
      mainAxisSpacing: itemSpacing,
      // ignore: no-equal-arguments
      crossAxisSpacing: itemSpacing,
      childAspectRatio: childAspect,
      children: [
        ...prefixes.map((e) => ImageFolderButton(item: e)),
        // ignore: avoid-slow-collection-methods
        ...items.mapIndexed(
          (index, item) =>
              ImageFileButton(index: index, item: item, items: items),
        ),
      ],
    );
  }
}

Future<List<Reference>> sortItemsByDate(List<Reference> items) async {
  final metadataList = await Future.wait(items.map((e) => e.getMetadata()));
  // Sort items by last modified date
  metadataList.sort(
    (a, b) => -1 * a.timeCreated!.compareTo(b.timeCreated!),
  );

  final sortedItems = metadataList.map((toElement) {
    final index =
        items.indexWhere((element) => element.fullPath == toElement.fullPath);
    return items[index];
  }).toList();

  return sortedItems;
}
