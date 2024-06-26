import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ksrvnjord_main_app/src/features/gallery/utils/get_thumbnail_reference.dart';
import 'package:ksrvnjord_main_app/src/features/shared/model/thumbnail.dart';
import 'package:styled_widget/styled_widget.dart';

class FileButton extends ConsumerWidget {
  const FileButton({super.key, required this.item});

  final Reference item;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final image = getThumbnailReference(item, Thumbnail.x400)
        .getDownloadURL(); // TODO: We should get 800x800 thumbnail if we are in LIST mode, IF we are in GRID mode, we should get 400x400 thumbnail.
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
      onTap: () => navigator.pushNamed("_file/${item.fullPath}").ignore(),
      splashColor: Colors.blue,
    );
  }
}
