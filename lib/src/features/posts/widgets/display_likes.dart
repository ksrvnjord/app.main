import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:styled_widget/styled_widget.dart';

class DisplayLikes extends StatelessWidget {
  final DocumentReference docRef;
  final List<String> likedBy;

  final double iconSize;
  const DisplayLikes({
    Key? key,
    required this.docRef,
    required this.likedBy,
    required this.iconSize,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    final bool liked = likedBy.contains(uid);

    return [
      IconButton(
        padding: const EdgeInsets.all(0),
        constraints: BoxConstraints.tight(Size.square(iconSize)),
        iconSize: iconSize,
        onPressed: () => liked
            ? docRef.update({
                'likes': FieldValue.arrayRemove([uid]),
              })
            : docRef.update({
                'likes': FieldValue.arrayUnion([uid]),
              }),
        icon: Icon(
          liked ? Icons.favorite_rounded : Icons.favorite_outline_rounded,
          color: liked ? Colors.red : Colors.black,
        ),
      ),
      // show amount of likes
      Text(likedBy.length.toString()),
    ].toRow();
  }
}
