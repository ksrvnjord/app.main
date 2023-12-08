import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:ksrvnjord_main_app/src/features/posts/model/post.dart';
import 'package:ksrvnjord_main_app/src/features/shared/model/current_user.dart';

class PostService {
  static final postsCollection = FirebaseFirestore.instance
      .collection('posts')
      .withConverter<Post>(
        fromFirestore: (snapshot, _) => Post.fromJson(snapshot.data() ?? {}),
        toFirestore: (post, _) => post.toJson(),
      );

  static deletePost(String path) async {
    await FirebaseFirestore.instance.doc(path).delete();
  }

  static like(DocumentSnapshot<Post> snapshot) {
    final uid = FirebaseAuth.instance.currentUser?.uid;
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
    File? image,
  }) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw Exception("User is null");
    }

    if (image != null) {
      final ref = FirebaseStorage.instance.ref("prikbord/afbeelding.jpg");
      ref.putFile(image);
    }

    // ignore: avoid-ignoring-return-values
    await postsCollection.add(Post(
      title: title,
      content: content,
      authorId: user.uid,
      authorName: "${currentUser.first_name} ${currentUser.last_name}",
      createdTime: Timestamp.now(),
      topic: topic,
    ));
  }
}
