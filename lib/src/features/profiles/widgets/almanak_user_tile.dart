import 'package:flutter/material.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/widgets/profile_picture_widget.dart';
import 'package:routemaster/routemaster.dart';

class AlmanakUserTile extends StatelessWidget {
  const AlmanakUserTile({
    super.key,
    required this.firstName,
    required this.lastName,
    this.subtitle,
    required this.lidnummer,
  });
  final String firstName;
  final String lastName;
  final String? subtitle;
  final String lidnummer;

  @override
  Widget build(BuildContext context) => ListTile(
        leading: ProfilePictureWidget(userId: lidnummer),
        title: Text("$firstName $lastName"),
        subtitle: subtitle != null ? Text(subtitle!) : null,
        onTap: () => Routemaster.of(context).push(lidnummer),
      );
}
