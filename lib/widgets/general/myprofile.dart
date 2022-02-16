import 'package:flutter/material.dart';
import 'package:ksrvnjord_main_app/pages/main/user/me.dart';

class MyProfileCard extends StatelessWidget {
  const MyProfileCard({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(12),
      child: Card(
        margin: EdgeInsets.zero,
        clipBehavior: Clip.antiAlias,
        color: Colors.white,
        elevation: 1,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
        child: IconButton(
            icon: const Icon(Icons.account_circle_rounded),
            color: Colors.grey,
            padding: EdgeInsets.zero,
            iconSize: 24,
            alignment: Alignment.center,
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const MePage()));
            }),
      ),
    );
  }
}
