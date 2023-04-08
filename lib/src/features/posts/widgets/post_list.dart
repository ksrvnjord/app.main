import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expand_widget/expand_widget.dart';
import 'package:flutter/material.dart';
import 'package:ksrvnjord_main_app/src/features/posts/model/post.dart';
import 'package:ksrvnjord_main_app/src/features/posts/widgets/comment_list.dart';
import 'package:ksrvnjord_main_app/src/features/posts/widgets/display_likes.dart';

class PostList extends StatelessWidget {
  final QuerySnapshot<Post> snapshot;
  const PostList({Key? key, required this.snapshot}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: snapshot.size,
      itemBuilder: ((context, index) {
        final doc = snapshot.docs[index];
        final post = doc.data();

        return Card(
          margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
          elevation: 1,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(16)),
          ),
          child: Column(children: [
            Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Icon(
                Icons.person,
                size: 40,
              ),
              const SizedBox(width: 20),
              Text(
                post.title,
                style:
                    const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              DisplayLikes(
                docRef: doc.reference,
                likedBy: post.likedBy,
                iconSize: 20,
              ),
            ]),
            Text(post.content),
            const Divider(),
            ExpandChild(child: CommentList(post: doc)),
          ]),
        );
      }),
    );
  }
}
