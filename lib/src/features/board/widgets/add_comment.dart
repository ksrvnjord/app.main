import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_it/get_it.dart';
import 'package:ksrvnjord_main_app/src/features/shared/model/current_user.dart';

class AddComment extends StatefulWidget {
  final QueryDocumentSnapshot<Object?> post;
  const AddComment({super.key, required this.post});

  @override
  AddCommentState createState() {
    return AddCommentState();
  }
}

class AddCommentState extends State<AddComment> {
  TextEditingController contentField = TextEditingController();

  QuerySnapshot? topicsSnapshot;
  @override
  Widget build(BuildContext context) {
    FirebaseFirestore db = FirebaseFirestore.instance;
    User user = FirebaseAuth.instance.currentUser!;
    var userName = GetIt.I.get<CurrentUser>().user!.fullContact.public;

    return Row(children: [
      SizedBox(
        width: 250,
        child: TextField(
          controller: contentField,
          decoration: const InputDecoration(
            hintText: "Reageer...",
          ),
        ),
      ),
      const Spacer(),
      IconButton(
        icon: const Icon(Icons.send, size: 12),
        color: Colors.blue,
        onPressed: () {
          db
              .collection('posts')
              .doc(widget.post.id)
              .collection('comments')
              .add({
            'authorId': user.uid,
            'authorName': '${userName.first_name!} ${userName.last_name!}',
            'content': contentField.text,
            'createdTime': DateTime.now(),
            'likes': [],
          });
          setState(() => {contentField.clear()});
        },
      ),
    ]);
  }
}
