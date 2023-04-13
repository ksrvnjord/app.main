import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ksrvnjord_main_app/src/features/shared/model/firebase_user.dart';
import 'package:styled_widget/styled_widget.dart';

class AuthorWidget extends ConsumerWidget {
  final String authorName;
  final String authorId;
  final double fontSize;

  const AuthorWidget({
    Key? key,
    required this.authorName,
    required this.authorId,
    // ignore: no-magic-number
    this.fontSize = 18.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final postAuthor = ref.watch(firestoreUserProvider(authorId));

    return [
      Text(authorName).fontWeight(FontWeight.bold).fontSize(fontSize),
      // twitter checkmark
      if (postAuthor != null && (postAuthor.isBestuur || postAuthor.isAppCo))
        Icon(
          Icons.verified,
          size: fontSize,
          color: postAuthor.isAppCo ? Colors.amber : Colors.lightBlue,
        ),
    ].toRow(
      separator: const SizedBox(width: 4),
      mainAxisSize: MainAxisSize.min,
    );
  }
}
