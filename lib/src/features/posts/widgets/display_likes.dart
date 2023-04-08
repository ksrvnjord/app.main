import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DisplayLikes extends StatelessWidget {
  final CollectionReference pathToLikeableObject;
  final QueryDocumentSnapshot<Object?> likableObject;
  final double iconSize;
  const DisplayLikes(
      {Key? key,
      required this.pathToLikeableObject,
      required this.likableObject,
      required this.iconSize})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    return likableObject.get('likes').contains(uid)
        ? IconButton(
            padding: const EdgeInsets.all(0),
            constraints: BoxConstraints.tight(Size(iconSize, iconSize)),
            iconSize: iconSize,
            onPressed: () => pathToLikeableObject.doc(likableObject.id).update({
                  'likes': FieldValue.arrayRemove([uid])
                }),
            icon: const Icon(
              Icons.favorite_rounded,
              color: Colors.red,
            ))
        : IconButton(
            padding: const EdgeInsets.all(0),
            constraints: BoxConstraints.tight(Size(iconSize, iconSize)),
            iconSize: iconSize,
            onPressed: () => pathToLikeableObject.doc(likableObject.id).update({
                  'likes': FieldValue.arrayUnion([uid])
                }),
            icon: const Icon(
              Icons.favorite_outline_rounded,
              color: Colors.black,
            ));
  }
}
