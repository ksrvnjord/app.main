import 'package:flutter/material.dart';
import 'package:ksrvnjord_main_app/pages/main/almanak/almanak_profile.dart';

class AlmanakListView extends StatelessWidget {
  const AlmanakListView(this.users, {Key? key}) : super(key: key);

  final List<dynamic> users;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: users.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text((users[index]['contact']['first_name'] ?? '-') +
              ' ' +
              (users[index]['contact']['last_name'] ?? '-')),
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      AlmanakProfile(profileId: users[index]['id']),
                ));
          },
        );
      },
    );
  }
}
