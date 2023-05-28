import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ksrvnjord_main_app/src/features/posts/model/post.dart';
import 'package:ksrvnjord_main_app/src/features/posts/widgets/post_widget.dart';
import 'package:styled_widget/styled_widget.dart';

class PostCard extends StatelessWidget {
  const PostCard({
    Key? key,
    required this.snapshot,
    this.elevation = true,
    this.squareBorder = false,
    this.expandContent = false,
  }) : super(key: key);

  final DocumentSnapshot<Post> snapshot;
  final bool elevation;
  final bool squareBorder;
  final bool expandContent;

  @override
  Widget build(BuildContext context) {
    const double postPadding = 8;

    return Container(
      child: [
        PostWidget(
          snapshot: snapshot,
          expanded: expandContent,
        ).padding(all: postPadding),
        const Divider(
          height: 0,
        ),
      ].toColumn(),
    );
  }
}
