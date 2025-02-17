import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ksrvnjord_main_app/src/features/documents/api/storage_path_children_provider.dart';
import 'package:styled_widget/styled_widget.dart';

class DocumentFolderButton extends ConsumerWidget {
  const DocumentFolderButton({
    super.key,
    required this.item,
  });

  final Reference item;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const maxLines = 2;
    const iconSize = 64.0;

    List<String> splitPath = item.fullPath.split('documents/');

    final itemChildrenVal = ref.watch(storagePathChildrenProvider(item));

    final textTheme = Theme.of(context).textTheme;

    return InkWell(
      child: [
        const Icon(Icons.folder, size: iconSize),
        Text(
          item.name,
          style: textTheme.bodyLarge,
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis,
          maxLines: maxLines,
        ),
        Text(
          itemChildrenVal.when(
            data: (children) {
              final length = children.prefixes.length +
                  children.items.length; // All "folders" and files.

              return "$length item${length > 1 || length == 0 ? 's' : ''}";
            },
            loading: () => "Laden...",
            error: (err, trace) => "Niet gelukt om te laden",
          ),
          style: textTheme.labelSmall,
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis,
          maxLines: maxLines,
        ),
      ].toColumn(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
      ),
      onTap: () => Navigator.of(context)
          .pushNamed(splitPath.length > 1 ? splitPath[1] : ''),
    );
  }
}
