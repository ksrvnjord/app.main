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

  static const double likeTextLeftPadding = 4;

  @override
  Widget build(BuildContext context) {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    final bool liked = likedBy.contains(uid);

    return GestureDetector(
      onTap: () => liked
          ? docRef.update({
              'likes': FieldValue.arrayRemove([uid]),
            })
          : docRef.update({
              'likes': FieldValue.arrayUnion([uid]),
            }),
      child: [
        IconButton(
          padding: const EdgeInsets.all(0),
          constraints: BoxConstraints.tight(Size.square(iconSize)),
          iconSize: iconSize,
          onPressed: () => {},
          icon: Icon(
            liked ? Icons.favorite_rounded : Icons.favorite_outline_rounded,
            color: liked ? Colors.red : Colors.black,
          ),
        ),
        const Text("Vind ik leuk").padding(left: likeTextLeftPadding),
      ].toRow(),
    );
  }
}
