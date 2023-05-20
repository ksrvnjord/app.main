import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ksrvnjord_main_app/assets/svgs.dart';
import 'package:ksrvnjord_main_app/src/features/posts/api/post_service.dart';
import 'package:ksrvnjord_main_app/src/features/posts/model/post.dart';
import 'package:routemaster/routemaster.dart';
import 'package:styled_widget/styled_widget.dart';

class PostBottomActionBar extends StatelessWidget {
  const PostBottomActionBar({
    Key? key,
    required this.snapshot,
  }) : super(key: key);

  final DocumentSnapshot<Post> snapshot;

  @override
  Widget build(BuildContext context) {
    final post = snapshot.data()!;
    String uid = FirebaseAuth.instance.currentUser!.uid;
    final bool likedByMe = post.likedBy.contains(uid);

    const double likeTextLeftPadding = 4;
    const iconSize = 20.0;

    const double fontSize = 16;
    const likeIconSize = 20.0;

    return [
      InkWell(
        onTap: () => PostService.like(snapshot),
        child: [
          SvgPicture.asset(
            Svgs.swanWhite,
            width: likeIconSize,
            // ignore: deprecated_member_use
            color: likedByMe ? Colors.lightBlue : null,
            // ignore: no-equal-arguments
            height: likeIconSize,
          ),
          const Text("Zwaan")
              .textColor(likedByMe ? Colors.lightBlue : null)
              .fontSize(fontSize),
        ].toRow(separator: const SizedBox(width: likeTextLeftPadding)),
      ),
      InkWell(
        onTap: () => Routemaster.of(context).push('${snapshot.id}/comments'),
        child: [
          const Icon(
            Icons.mode_comment_outlined,
            size: iconSize,
          ),
          const Text("Reageer").fontSize(fontSize),
        ].toRow(
          separator: const SizedBox(width: 4),
        ),
      ),
    ].toRow(mainAxisAlignment: MainAxisAlignment.spaceAround);
  }
}
