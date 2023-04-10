import 'package:cloud_firestore/cloud_firestore.dart';

class CommentsService {
  static deleteComment(String path) {
    FirebaseFirestore.instance.doc(path).delete();
  }
}
