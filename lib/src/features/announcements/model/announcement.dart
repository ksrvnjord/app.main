// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:cloud_firestore/cloud_firestore.dart';

class Announcement {
  final String id;
  final String author;
  final String? link;
  final Timestamp createdAt;

  @override
  int get hashCode {
    return author.hashCode ^ link.hashCode ^ createdAt.hashCode ^ id.hashCode;
  }

  Announcement({
    required this.id,
    required this.author,
    this.link,
    required this.createdAt,
  });

  factory Announcement.fromMap(Map<String, dynamic> map) {
    return Announcement(
      id: map['id'] as String,
      author: map['author'] as String,
      createdAt: map['created_at'] as Timestamp,
      link: map['link'] as String?,
    );
  }

  @override
  bool operator ==(covariant Announcement other) {
    if (identical(this, other)) return true;

    return other.author == author &&
        other.link == link &&
        other.createdAt == createdAt &&
        other.id == id;
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'author': author,
      'link': link,
      'created_at': createdAt,
      'id': id,
    };
  }

  Announcement copyWith({
    String? id,
    String? author,
    String? link,
    Timestamp? createdAt,
  }) {
    return Announcement(
      id: id ?? this.id,
      author: author ?? this.author,
      link: link ?? this.link,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  String toString() {
    return 'Announcement(id: $id, author: $author, createdAt: $createdAt, link: $link)';
  }
}
