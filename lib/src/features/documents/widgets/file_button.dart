import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:ksrvnjord_main_app/src/features/documents/api/file_metadata_provider.dart';
import 'package:styled_widget/styled_widget.dart';

class FileButton extends ConsumerWidget {
  final Reference item;

  const FileButton({
    super.key,
    required this.item,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const maxLines = 2;
    const iconSize = 64.0;

    final metadataVal = ref.watch(fileMetadataProvider(item));

    final Characters fileName = item.name.characters.getRange(
      0,
      item.name.lastIndexOf('.'),
    );

    final textTheme = Theme.of(context).textTheme;
    final labelSmall = textTheme.labelSmall;

    return InkWell(
      child: [
        [
          const Icon(
            Icons.insert_drive_file,
            size: iconSize,
          ),
          // Add White text "PDF".
          Text(
            item.name.characters
                .getRange(item.name.lastIndexOf('.') + 1, item.name.length)
                .string
                .toUpperCase(),
            style: labelSmall?.copyWith(
              color: Theme.of(context).colorScheme.onInverseSurface,
            ),
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            maxLines: maxLines,
          ),
        ].toStack(alignment: Alignment.center),
        Text(
          fileName.string,
          style: textTheme.bodyLarge,
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis,
          maxLines: maxLines,
        ),
        Text(
          metadataVal.when(
            data: (metadata) {
              final DateTime? updated = metadata.updated;

              return updated != null
                  ? DateFormat("dd/MM/yyyy").format(updated)
                  : "";
            },
            error: (err, trace) => "Metadata niet beschikbaar",
            loading: () => "Laden...",
          ),
          style: labelSmall,
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis,
          maxLines: maxLines,
        ),
      ].toColumn(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
      ),
      onTap: () => Navigator.of(context).pushNamed("_file/${item.fullPath}"),
    );
  }
}
