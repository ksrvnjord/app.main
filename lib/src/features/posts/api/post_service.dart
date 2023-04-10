import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:ksrvnjord_main_app/src/features/posts/model/post.dart';
import 'package:ksrvnjord_main_app/src/features/posts/model/topic.dart';
import 'package:ksrvnjord_main_app/src/features/shared/model/current_user.dart';

class PostService {
  static final postsCollection =
      FirebaseFirestore.instance.collection('posts').withConverter<Post>(
            fromFirestore: (snapshot, _) => Post.fromJson(snapshot.data()!),
            toFirestore: (post, _) => post.toJson(),
          );

  static deletePost(String path) {
    FirebaseFirestore.instance.doc(path).delete();
  }

  static like(DocumentSnapshot<Post> snapshot) {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final post = snapshot.data()!;
    final likedByMe = post.likedBy.contains(uid);
    snapshot.reference.update({
      'likes': likedByMe
          ? FieldValue.arrayRemove([uid])
          : FieldValue.arrayUnion([uid]),
    });
  }

  static Future<void> create({
    required Topic topic,
    required String title,
    required String content,
  }) async {
    final me = GetIt.I<CurrentUser>().user!.fullContact.private!;

    await postsCollection.add(Post(
      topic: topic.name,
      title: title,
      content: content,
      createdTime: Timestamp.now(),
      authorId: FirebaseAuth.instance.currentUser!.uid,
      authorName: "${me.first_name} ${me.last_name}",
    ));
  }
}
