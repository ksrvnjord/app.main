import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ksrvnjord_main_app/src/features/posts/model/post.dart';
import 'package:ksrvnjord_main_app/src/features/posts/widgets/post_widget.dart';
import 'package:styled_widget/styled_widget.dart';

class PostCard extends StatelessWidget {
  const PostCard({
    Key? key,
    required this.snapshot,
    this.margin = true,
    this.elevation = true,
    this.squareBorder = false,
  }) : super(key: key);

  final DocumentSnapshot<Post> snapshot;
  final bool margin;
  final bool elevation;
  final bool squareBorder;

  @override
  Widget build(BuildContext context) {
    const double postPadding = 8;

    return PostWidget(snapshot: snapshot).padding(all: postPadding).card(
          margin: margin ? const EdgeInsets.all(8) : null,
          elevation: elevation ? 1 : 0,
          shape: RoundedRectangleBorder(
            borderRadius: squareBorder
                ? BorderRadius.zero
                : const BorderRadius.all(Radius.circular(16)),
          ),
        );
  }
}
