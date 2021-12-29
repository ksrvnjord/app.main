import 'package:flutter/material.dart';

class UserAvatar extends StatelessWidget {
  const UserAvatar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      height: 150,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
      ),
      child: const FittedBox(
        fit: BoxFit.fill,
        child: Icon(
          Icons.account_circle_rounded,
          color: Colors.grey,
        ),
      ),
    );
  }
}
