import 'package:flutter/material.dart';
import 'package:ksrvnjord_main_app/assets/images.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/api/almanak.graphql.dart';
import 'package:routemaster/routemaster.dart';
import 'package:styled_widget/styled_widget.dart';

class AlmanakUserButtonWidget extends StatelessWidget {
  final Query$Almanak$users$data user;

  const AlmanakUserButtonWidget(this.user, {Key? key}) : super(key: key);
@override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Routemaster.of(context).push('/almanak/${user.id}');
      },
      child: Card(
        child: ListTile(
          leading: CircleAvatar(
            backgroundImage: Image.asset(Images.placeholderProfilePicture).image,
          ),
          title: Text((user.fullContact.public.first_name ?? '')+
              ' ' +
              (user.fullContact.public.last_name ?? '')),
          onTap: () {
            Routemaster.of(context).push('/almanak/${user.id}');
          },
        ),
      ),
    );
  }

}
