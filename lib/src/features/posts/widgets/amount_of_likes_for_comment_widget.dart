import 'package:flutter/material.dart';
import 'package:styled_widget/styled_widget.dart';

class AmountOfLikesForCommentWidget extends StatelessWidget {
  final int amountOfLikes;

  const AmountOfLikesForCommentWidget({Key? key, required this.amountOfLikes})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      // make edges round
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(40)),
        color: Colors.lightBlue.shade300,
        // add shadow
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 2,
            offset: const Offset(0, 1), // changes position of shadow
          ),
        ],
      ),
      child: [
        const Icon(
          Icons.favorite,
          color: Colors.white,
          size: 12,
        ).padding(right: 2),
        Text(amountOfLikes.toString())
            .fontWeight(FontWeight.bold)
            .fontSize(12)
            .textColor(Colors.white),
      ]
          .toRow(
            mainAxisSize: MainAxisSize.min,
          )
          .padding(horizontal: 2),
    );
  }
}
