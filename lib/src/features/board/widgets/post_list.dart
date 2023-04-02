import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expand_widget/expand_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ksrvnjord_main_app/src/features/board/widgets/comment_list.dart';
import 'package:ksrvnjord_main_app/src/features/board/widgets/display_likes.dart';

class PostList extends StatelessWidget {
  final AsyncSnapshot<QuerySnapshot<Object?>> snapshot;
  const PostList({Key? key, required this.snapshot}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    FirebaseFirestore db = FirebaseFirestore.instance;
    return ListView.builder(
        itemCount: snapshot.data!.size,
        itemBuilder: ((context, index) {
          QueryDocumentSnapshot doc = snapshot.data!.docs[index];
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
                    doc.get('title'),
                    style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  const Spacer(),
                  Text(doc.get('likes').length.toString()),
                  DisplayLikes(
                      pathToLikeableObject: db.collection('posts'),
                      likableObject: doc,
                      iconSize: 20),
                ]),
                Text(doc.get('content')),
                const Divider(),
                ExpandChild(child: CommentList(post: doc))
              ]));
        }));
  }
}
