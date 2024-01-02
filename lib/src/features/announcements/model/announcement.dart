// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class Announcement {
  final String author;
  final String contents;
  final Timestamp createdAt;
  final String title;
  final Timestamp updatedAt;

  @override
  int get hashCode {
    return author.hashCode ^
        contents.hashCode ^
        createdAt.hashCode ^
        title.hashCode ^
        updatedAt.hashCode;
  }

  Announcement({
    required this.author,
    required this.contents,
    required this.createdAt,
    required this.title,
    required this.updatedAt,
  });

  factory Announcement.fromMap(Map<String, dynamic> map) {
    return Announcement(
      author: map['author'] as String,
      contents: map['contents'] as String,
      createdAt: map['created_at'] as Timestamp,
      title: map['title'] as String,
      updatedAt: map['updated_at'] as Timestamp,
    );
  }

  @override
  bool operator ==(covariant Announcement other) {
    if (identical(this, other)) return true;

    return other.author == author &&
        other.contents == contents &&
        other.createdAt == createdAt &&
        other.title == title &&
        other.updatedAt == updatedAt;
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'author': author,
      'contents': contents,
      'created_at': createdAt,
      'title': title,
      'updated_at': updatedAt,
    };
  }

  String toJson() => json.encode(toMap());

  @override
  String toString() {
    return 'Announcement(author: $author, contents: $contents, createdAt: $createdAt, title: $title, updatedAt: $updatedAt)';
  }
}
