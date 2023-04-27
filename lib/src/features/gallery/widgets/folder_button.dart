import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';
import 'package:styled_widget/styled_widget.dart';

const maxLines = 2;
const padding = 12.0;
const iconSize = 42.0;

class FolderButton extends ConsumerWidget {
  final Reference item;

  const FolderButton({
    Key? key,
    required this.item,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final navigator = Navigator.of(context);

    return InkWell(
      onTap: () => navigator.pushNamed(item.fullPath),
      child: [
        const Icon(Icons.folder, size: iconSize),
        Text(
          item.name.replaceAll('-', ' '),
          softWrap: true,
          maxLines: maxLines,
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ]
          .toColumn(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
          )
          .padding(all: padding),
    );
  }
}
