import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/api/profile.graphql.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/pages/almanak_profile/widgets/almanak_profile_bottomsheet_widget.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/widgets/profile_picture_widget.dart';
import 'package:styled_widget/styled_widget.dart';

class AlmanakUserProfileView extends StatelessWidget {
  const AlmanakUserProfileView({
    super.key,
    required this.user,
  });

  final Query$AlmanakProfile$user user;

  @override
  Widget build(BuildContext context) {
    const double profilePictureSize = 96;
    const double profilePicturePadding = 8;

    return ListView(
      children: [
        ProfilePictureWidget(
          userId: user.identifier,
          size: profilePictureSize,
        ).padding(all: profilePicturePadding).center(),
      ],
    );
  }

  Widget showUserProfile(Query$AlmanakProfile$user? user) {
    final contact = user!.fullContact.public;

    const List<String> labels = [
      'Naam',
      'Telefoonnummer',
      'E-mailadres',
      'Adres',
      'Postcode',
      'Woonplaats',
    ];

    final List<String> values = [
      '${contact.first_name} ${contact.last_name}',
      contact.phone_primary ?? '',
      contact.email ?? '',
      contact.street != ''
          ? '${contact.street ?? ''} ${contact.housenumber ?? ''} ${contact.housenumber_addition ?? ''}'
          : '',
      contact.zipcode ?? ' ',
      contact.city ?? ' ',
    ];

    const double textFieldPadding = 16;

    return Column(
      children: [
        // ignore: avoid-shrink-wrap-in-lists
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: labels.length,
          itemBuilder: (BuildContext context, int index) {
            if (values[index] != '') {
              return GestureDetector(
                child: TextFormField(
                  enabled: false,
                  decoration: InputDecoration(
                    labelText: labels[index],
                    border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(16)),
                    ),
                  ),
                  initialValue: values[index],
                ).padding(all: textFieldPadding),
                onLongPress: () => vibrateAndshowBottomSheet(
                  context,
                  labels[index],
                  values[index],
                ),
              );
            } else {
              return Container();
            }
          },
        ),
      ],
    );
  }

  void vibrateAndshowBottomSheet(context, label, value) {
    HapticFeedback.vibrate();
    showModalBottomSheet(
      context: context,
      builder: (_) => AlmanakProfileBottomsheetWidget(
        label: label,
        value: value,
      ),
    );
  }
}
