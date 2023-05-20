import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ksrvnjord_main_app/src/features/posts/model/comment.dart';

class CommentsService {
  static deleteComment(String path) {
    FirebaseFirestore.instance.doc(path).delete();
  }

  static like(QueryDocumentSnapshot<Comment> snapshot) {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    final comment = snapshot.data();
    final likedByMe = comment.likedBy.contains(uid);
    snapshot.reference.update({
      'likes': likedByMe
          ? FieldValue.arrayRemove([uid])
          : FieldValue.arrayUnion([uid]),
    });
  }
}
