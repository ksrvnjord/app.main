import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

@immutable
class Comment {
  final String authorId;
  final String authorName;
  final String content;
  final Timestamp createdTime;
  final List<String> likedBy;

  const Comment({
    required this.authorId,
    required this.authorName,
    required this.content,
    required this.createdTime,
    required this.likedBy,
  });

  factory Comment.fromMap(Map<String, dynamic> map) {
    return Comment(
      authorId: map['authorId'] as String,
      authorName: map['authorName'] as String,
      content: map['content'] as String,
      createdTime: map['createdTime'] as Timestamp,
      likedBy: List<String>.from(map['likes']),
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
}
