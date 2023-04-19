import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ksrvnjord_main_app/src/features/gallery/utils/get_thumbnail_reference.dart';
import 'package:styled_widget/styled_widget.dart';

const maxLines = 2;
const padding = 12.0;
const iconSize = 42.0;
const imageHeight = 38.0;

class FileButton extends ConsumerWidget {
  final Reference item;
  const FileButton({
    Key? key,
    required this.item,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final image = getThumbnailReference(item).getDownloadURL();

    return InkWell(
      splashColor: Colors.blue,
      child: FutureBuilder(
        future: image,
        builder: (_, snapshot) => snapshot.hasData
            ? ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(padding)),
                child: Image.network(snapshot.data!, fit: BoxFit.cover),
              )
            : const Icon(Icons.image, size: iconSize),
      ).padding(all: padding).borderRadius(all: padding),
    );
  }
}
