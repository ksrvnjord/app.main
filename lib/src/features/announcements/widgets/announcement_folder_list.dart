import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:collection/collection.dart';
import 'package:ksrvnjord_main_app/src/features/gallery/utils/gallery_view_provider.dart';
import 'package:ksrvnjord_main_app/src/features/gallery/widgets/image_file_button.dart';

/// This widget displays a grid of images or folders with images in it.
/// Changes made to this widget should also be reflected in [ImagesFolderList].
/// Because that file closely resembles this one. Apart from minor changes.

class AnnouncementFolderList extends ConsumerStatefulWidget {
  const AnnouncementFolderList(
      {super.key, required this.items, this.isAnnouncement = false});
  final List<Reference> items;
  final bool isAnnouncement;

  @override
  createState() => _AnnouncementFolderListState();
}

class _AnnouncementFolderListState
    extends ConsumerState<AnnouncementFolderList> {
  @override
  Widget build(BuildContext context) {
    final gridOrList = ref.watch(gridOrListViewProvider);
    var items = widget.items;

    // Remove the sacred "thumbnails" folder.
    // prefixes.retainWhere((e) => !e.fullPath.contains('thumbnails'));

    int crossAxisCount = 3;
    double childAspect = 1.0;
    const itemSpacing = 8.0;

    if (gridOrList) {
      crossAxisCount = 1;
      const num = 1.5;
      childAspect = num;
    }

    // Sorteer aankondigingen op datum.
    return FutureBuilder(
      future: sortItemsByDate(items),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator.adaptive());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (snapshot.hasData) {
          final sortedItems = snapshot.data!;

          return GridView.count(
            padding: const EdgeInsets.all(8),
            crossAxisCount: crossAxisCount,
            mainAxisSpacing: itemSpacing,
            // ignore: no-equal-arguments
            crossAxisSpacing: itemSpacing,
            childAspectRatio: childAspect,
            children: [
              // ignore: avoid-slow-collection-methods
              ...sortedItems.mapIndexed(
                (index, item) => ImageFileButton(
                    index: index, item: item, items: sortedItems),
              ),
            ],
          );
        } else {
          return const Center(child: Text('Geen aankondigingen gevonden.'));
        }
      },
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
