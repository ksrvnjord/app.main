import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:ksrvnjord_main_app/src/features/posts/model/post.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/models/user.dart';

class PostService {
  static final postsCollection = FirebaseFirestore.instance
      .collection('posts')
      .withConverter<Post>(
        fromFirestore: (snapshot, _) => Post.fromJson(snapshot.data() ?? {}),
        toFirestore: (post, _) => post.toJson(),
      );

  static deletePost(DocumentSnapshot<Post> snapshot) async {
    final post = snapshot.data();

    if (post?.imageRef != null) {
      await post?.imageRef?.delete();
    }
    snapshot.reference.delete();
  }

  static like(DocumentSnapshot<Post> snapshot) {
    final uid = firebase_auth.FirebaseAuth.instance.currentUser?.uid;
    final post = snapshot.data();
    final likedByMe = post?.likedBy.contains(uid) ?? false;
    snapshot.reference.update({
      'likes': likedByMe
          ? FieldValue.arrayRemove([uid])
          : FieldValue.arrayUnion([uid]),
    });
  }

  static Future<void> create({
    required String topic,
    required String title,
    required String content,
    required User currentUser,
    File? image,
  }) async {
    final postRef = postsCollection.doc(); // Make a new document reference.

    if (image == null) {
      await postRef.set(
        Post(
          title: title,
          content: content,
          authorId: currentUser.identifier.toString(),
          authorName: currentUser.fullName,
          createdTime: Timestamp.now(),
          topic: topic,
        ),
      );
    } else {
      final ref = FirebaseStorage.instance.ref("prikbord/${postRef.id}.png");
      try {
        // ignore: avoid-ignoring-return-values
        await ref.putFile(image);
        await postRef.set(
          Post(
            title: title,
            content: content,
            authorId: currentUser.identifier.toString(),
            authorName: currentUser.fullName,
            createdTime: Timestamp.now(),
            topic: topic,
            imageRef: ref,
          ),
        );

        return;
      } catch (error) {
        rethrow;
      }
    }
  }
}
