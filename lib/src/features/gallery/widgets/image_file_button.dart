import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ksrvnjord_main_app/src/features/gallery/utils/gallery_view_provider.dart';
import 'package:ksrvnjord_main_app/src/features/gallery/utils/get_thumbnail_reference.dart';
import 'package:ksrvnjord_main_app/src/features/shared/model/thumbnail.dart';
import 'package:styled_widget/styled_widget.dart';

/// This widget displays an image.

class ImageFileButton extends ConsumerWidget {
  const ImageFileButton({
    super.key,
    required this.index,
    required this.item,
    required this.items,
  });

  final int index;
  final Reference item;
  final List<Reference> items;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // ignore: prefer-boolean-prefixes
    final gridOrList = ref.watch(gridOrListViewProvider);
    final image = getThumbnailReference(
      item,
      gridOrList ? Thumbnail.x800 : Thumbnail.x400,
    ).getDownloadURL();
    final navigator = Navigator.of(context);

    const padding = 12.0;
    const iconSize = 42.0;

    return InkWell(
      // ignore: sort_child_properties_last
      child: FutureBuilder(
        future: image,
        builder: (_, snapshot) => snapshot.hasData
            ? ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(padding)),
                // ignore: avoid-non-null-assertion
                child: Image.network(snapshot.data!, fit: BoxFit.cover),
              )
            : const Icon(Icons.image, size: iconSize),
      ).borderRadius(all: padding),
      onTap: () => navigator.pushNamed(
        "_file/${item.fullPath}",
        arguments: {'initialIndex': index, 'paths': items},
      ).ignore(),
      splashColor: Colors.blue,
    );
  }
}
