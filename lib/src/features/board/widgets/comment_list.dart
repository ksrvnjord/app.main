import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ksrvnjord_main_app/src/features/board/widgets/add_comment.dart';
import 'package:ksrvnjord_main_app/src/features/board/widgets/display_likes.dart';

class CommentList extends StatelessWidget {
  final QueryDocumentSnapshot<Object?> post;
  const CommentList({Key? key, required this.post}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    CollectionReference<Map<String, dynamic>> commentsRef = FirebaseFirestore
        .instance
        .collection('posts')
        .doc(post.id)
        .collection('comments');

    return StreamBuilder(
      stream: commentsRef
          .orderBy('createdTime', descending: true)
          .limit(20)
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) {
          return const SizedBox(
            height: 40,
            child: Text('Er is iets misgegaan, probeer later opnieuw.'),
          );
        }
        if (snapshot.data!.size == 0) {
          return SizedBox(
            height: 66,
            child: Column(children: [
              AddComment(post: post),
              const Text('Er heeft nog niemand gereageerd.'),
            ]),
          );
        }
        if (snapshot.hasError) {
          return Text(snapshot.error.toString());
        } else {
          return Column(
            children: [
              AddComment(
                post: post,
              ),
              SizedBox(
                height: 180,
                child: ListView.builder(
                  itemCount: snapshot.data!.size,
                  itemBuilder: ((context, index) {
                    QueryDocumentSnapshot comment = snapshot.data!.docs[index];

                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      padding: const EdgeInsets.all(0),
                      color: index.isEven
                          ? Colors.grey.shade100
                          : Colors.grey.shade50,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(children: [
                            Text(
                              comment.get('authorName'),
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Spacer(),
                            Text(comment.get('likes').length.toString()),
                            DisplayLikes(
                              pathToLikeableObject: commentsRef,
                              likableObject: comment,
                              iconSize: 12,
                            ),
                          ]),
                          Text(
                            comment.get('content'),
                            style: const TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                    );
                  }),
                ),
              ),
            ],
          );
        }
      },
    );
  }
}
