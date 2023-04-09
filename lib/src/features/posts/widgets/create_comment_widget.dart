import 'package:flutter/material.dart';
import 'package:styled_widget/styled_widget.dart';

class CreateCommentWidget extends StatelessWidget {
  const CreateCommentWidget({
    Key? key,
    required this.postDocId,
  }) : super(key: key);

  final String postDocId;

  static const double sendIconPadding = 8;

  @override
  Widget build(BuildContext context) {
    return [
      const TextField(
        decoration: InputDecoration(
          contentPadding: EdgeInsets.all(8.0),
          hintText: 'Commenteer op deze post...',
          fillColor: Colors.white,
          filled: true,
          hintStyle: TextStyle(
            color: Colors.black26,
          ),
          border: InputBorder.none,
        ),
        maxLines: null,
      ).expanded(),
      const Icon(
        Icons.send,
        color: Colors.lightBlue,
      )
          .padding(all: sendIconPadding)
          .expanded(flex: 0), // expand in the cross axis
    ].toRow().backgroundColor(Colors.white);
  }
}
