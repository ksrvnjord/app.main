import 'package:flutter/material.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/models/firestore_user.dart';
import 'package:styled_widget/styled_widget.dart';

class AuthorWidget extends StatelessWidget {
  final String authorName;
  final FirestoreUser? postAuthor;
  final double fontSize;

  const AuthorWidget({
    Key? key,
    required this.postAuthor,
    required this.authorName,
    // ignore: no-magic-number
    this.fontSize = 18.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool? authorIsAppCo = postAuthor?.isAppCo;
    bool? authorIsBestuur = postAuthor?.isBestuur;

    return [
      Text(
        authorName,
        style: Theme.of(context).textTheme.titleMedium,
      ),
      // Twitter checkmark.
      if ((authorIsBestuur != null && authorIsBestuur) ||
          (authorIsAppCo != null && authorIsAppCo))
        Icon(
          Icons.verified,
          size: fontSize,
          color: authorIsAppCo != null
              ? authorIsAppCo
                  ? Colors.amber
                  : Colors.lightBlue
              : null,
        ),
    ].toRow(
      separator: const SizedBox(width: 4),
      mainAxisSize: MainAxisSize.min,
    );
  }
}
