import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

@immutable
class Post {
  final String title;
  final String content;
  final String authorId;
  final String authorName;
  final Timestamp createdTime;
  final List<String> likedBy;
  final String topic;

  const Post({
    required this.title,
    required this.content,
    required this.authorId,
    required this.authorName,
    required this.createdTime,
    required this.likedBy,
    required this.topic,
  });

  factory Post.fromJson(Map<String, dynamic> data) {
    return Post(
      title: data['title'],
      content: data['content'],
      authorId: data['authorId'],
      authorName: data['authorName'],
      createdTime: data['createdTime'],
      likedBy: List<String>.from(data['likes']),
      topic: data['topic'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'content': content,
      'authorId': authorId,
      'authorName': authorName,
      'createdTime': createdTime,
      'likes': likedBy,
      'topic': topic,
    };
  }
}
