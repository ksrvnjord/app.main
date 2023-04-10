import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';
import 'package:ksrvnjord_main_app/src/features/settings/api/me.graphql.dart';
import 'package:ksrvnjord_main_app/src/features/shared/model/current_user.dart';

@immutable
class Comment {
  final String authorId;
  final String authorName;
  final String content;
  final Timestamp createdTime;
  final List<String> likedBy;
  final bool likedByMe;

  const Comment({
    required this.authorId,
    required this.authorName,
    required this.content,
    required this.createdTime,
    this.likedBy = const [],
    this.likedByMe = false,
  });

  factory Comment.fromMap(Map<String, dynamic> map) {
    return Comment(
      authorId: map['authorId'] as String,
      authorName: map['authorName'] as String,
      content: map['content'] as String,
      createdTime: map['createdTime'] as Timestamp,
      likedBy: List<String>.from(map['likes']),
      likedByMe: List<String>.from(map['likes'])
          .contains(FirebaseAuth.instance.currentUser!.uid),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'authorId': authorId,
      'authorName': authorName,
      'content': content,
      'createdTime': createdTime,
      'likes': likedBy,
    };
  }

  static Future<DocumentReference<Comment>> createComment({
    required String content,
    required String postId,
  }) {
    Query$Me$me$fullContact$private private =
        GetIt.I<CurrentUser>().user!.fullContact.private!;
    String firstName = private.first_name!;
    String lastName = private.last_name!;

    return FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('comments')
        .withConverter<Comment>(
          fromFirestore: (snapshot, _) => Comment.fromMap(snapshot.data()!),
          toFirestore: (comment, _) => comment.toJson(),
        )
        .add(Comment(
          authorId: FirebaseAuth.instance.currentUser!.uid,
          authorName: "$firstName $lastName",
          content: content,
          createdTime: Timestamp.now(),
        ));
  }
}
