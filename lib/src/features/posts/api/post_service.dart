import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ksrvnjord_main_app/src/features/posts/model/post.dart';

class PostService {
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
}
