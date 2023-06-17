import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:ksrvnjord_main_app/src/features/documents/api/file_metadata_provider.dart';
import 'package:styled_widget/styled_widget.dart';

class FileButton extends ConsumerWidget {
  final Reference item;

  const FileButton({
    Key? key,
    required this.item,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const maxLines = 2;
    const iconSize = 56.0;

    final metadataVal = ref.watch(fileMetadataProvider(item));

    final Characters fileName = item.name.characters.getRange(
      0,
      item.name.lastIndexOf('.'),
    );

    return InkWell(
      child: [
        const Icon(
          Icons.insert_drive_file,
          size: iconSize,
        ),
        Text(
          fileName.string,
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis,
          maxLines: maxLines,
        ),
        metadataVal.when(
          data: (metadata) {
            final DateTime? updated = metadata.updated;

            return Text(
              updated != null ? DateFormat("dd/MM/yyyy").format(updated) : "",
              style: Theme.of(context).textTheme.labelSmall,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              maxLines: maxLines,
            );
          },
          loading: () => const Text(
            "Laden...",
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            maxLines: maxLines,
          ),
          error: (err, trace) => Text(
            err.toString(),
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            maxLines: maxLines,
          ),
        ),
      ].toColumn(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
      ),
      onTap: () => Navigator.of(context).pushNamed("_file/${item.fullPath}"),
    );
  }
}
