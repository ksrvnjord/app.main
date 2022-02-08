import 'package:flutter/material.dart';
import 'package:ksrvnjord_main_app/pages/me.dart';
import 'package:ksrvnjord_main_app/widgets/general/announcements.dart';

class MyProfileCard extends StatelessWidget {
  const MyProfileCard({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Card(
        color: Colors.white,
        elevation: 3,
        child: ListTile(
            title: const Icon(Icons.person, size: 40),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const MePage()));
            }),
      ),
    );
  }
}
