import 'package:flutter/material.dart';
import 'package:ksrvnjord_main_app/pages/main/almanak/almanak_profile.dart';

class AlmanakField extends StatelessWidget {
  const AlmanakField(this.user, {Key? key}) : super(key: key);

  final dynamic user;

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      TextButton(
        child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              (user['fullContact']['public']['first_name'] != null)
                  ? user['fullContact']['public']['last_name'] +
                      ', ' +
                      user['fullContact']['public']['first_name']
                  : user['username'],
              style: const TextStyle(fontSize: 16, color: Colors.black54),
            )),
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AlmanakProfile(profileId: user['id']),
              ));
        },
      ),
      const Divider(
        thickness: 1,
        color: Colors.black,
      )
    ]);
  }
}
