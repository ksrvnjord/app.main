import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ksrvnjord_main_app/src/features/gallery/utils/get_thumbnail_reference.dart';
import 'package:styled_widget/styled_widget.dart';

class FileButton extends ConsumerWidget {
  const FileButton({Key? key, required this.item}) : super(key: key);

  final Reference item;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final image = getThumbnailReference(item).getDownloadURL();
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
