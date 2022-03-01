import 'package:flutter/material.dart';
import 'package:ksrvnjord_main_app/pages/main/user/me.dart';

class MyProfileCard extends StatelessWidget {
  const MyProfileCard({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: IconButton(
          icon: const Icon(Icons.account_circle),
          color: Colors.white,
          padding: EdgeInsets.zero,
          iconSize: 32,
          alignment: Alignment.center,
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const MePage()));
          }),
    );
  }
}
