import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
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
  final Reference? imageRef;

  const Post({
    required this.title,
    required this.content,
    required this.authorId,
    required this.authorName,
    required this.createdTime,
    this.likedBy = const [],
    required this.topic,
    this.imageRef,
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
      imageRef: data['imageRef'] == null
          ? null
          : FirebaseStorage.instance.ref(data['imageRef']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'authorId': authorId,
      'authorName': authorName,
      'content': content,
      'createdTime': createdTime,
      'imageRef': imageRef?.fullPath,
      'likes': likedBy,
      'title': title,
      'topic': topic,
    };
  }
}
