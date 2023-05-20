import 'package:flutter/material.dart';
import 'package:ksrvnjord_main_app/src/features/shared/model/firebase_user.dart';
import 'package:styled_widget/styled_widget.dart';

class AuthorWidget extends StatelessWidget {
  final String authorName;
  final FirebaseUser? postAuthor;
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
      Text(authorName).fontWeight(FontWeight.bold).fontSize(fontSize),
      // Twitter checkmark.
      if (postAuthor != null && (authorIsBestuur! || authorIsAppCo!))
        Icon(
          Icons.verified,
          size: fontSize,
          color: authorIsAppCo! ? Colors.amber : Colors.lightBlue,
        ),
    ].toRow(
      separator: const SizedBox(width: 4),
      mainAxisSize: MainAxisSize.min,
    );
  }
}
