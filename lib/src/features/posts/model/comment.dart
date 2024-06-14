import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

@immutable
class Comment {
  final String authorId;
  final String authorName;
  final String content;
  final Timestamp createdTime;
  final List<String> likedBy;
  final bool likedByMe;

  // ignore: sort_constructors_first
  const Comment({
    required this.authorId,
    required this.authorName,
    required this.content,
    required this.createdTime,
    this.likedBy = const [],
    this.likedByMe = false,
  });

  // ignore: sort_constructors_first
  factory Comment.fromMap(Map<String, dynamic> map) {
    return Comment(
      authorId: map['authorId'] as String,
      authorName: map['authorName'] as String,
      content: map['content'] as String,
      createdTime: map['createdTime'] as Timestamp,
      likedBy: List<String>.from(map['likes']),
      likedByMe: List<String>.from(map['likes'])
          .contains(FirebaseAuth.instance.currentUser?.uid),
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
    required String authorName,
  }) {
    return FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('comments')
        .withConverter<Comment>(
          fromFirestore: (snapshot, _) =>
              Comment.fromMap(snapshot.data() ?? {}),
          toFirestore: (comment, _) => comment.toJson(),
        )
        .add(Comment(
          authorId: FirebaseAuth.instance.currentUser?.uid ?? "",
          authorName: authorName,
          content: content,
          createdTime: Timestamp.now(),
        ));
  }
}
