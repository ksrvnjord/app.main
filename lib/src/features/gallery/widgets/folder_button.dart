import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:styled_widget/styled_widget.dart';

class FolderButton extends ConsumerWidget {
  final Reference item;

  const FolderButton({
    Key? key,
    required this.item,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const maxLines = 2;
    const padding = 12.0;
    const iconSize = 42.0;

    return InkWell(
      child: [
        const Icon(Icons.folder, size: iconSize),
        Text(
          item.name.replaceAll('-', ' '),
          style: const TextStyle(fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
          softWrap: true,
          overflow: TextOverflow.ellipsis,
          maxLines: maxLines,
        ),
      ]
          .toColumn(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
          )
          .padding(all: padding),
      onTap: () => Navigator.of(context).pushNamed(item.name),
    );
  }
}
