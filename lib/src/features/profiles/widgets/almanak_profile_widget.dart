import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ksrvnjord_main_app/assets/images.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/api/profile_picture.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/models/profile.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/widgets/almanak_profile_bottomsheet_widget.dart';
import 'package:ksrvnjord_main_app/src/features/shared/model/graphql_model.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/future_wrapper.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/shimmer_widget.dart';
import 'package:provider/provider.dart';
import 'package:styled_widget/styled_widget.dart';

class AlmanakProfileWidget extends StatelessWidget {
  final String profileId;

  const AlmanakProfileWidget({super.key, required this.profileId});

  @override
  Widget build(BuildContext context) {
    final client = Provider.of<GraphQLModel>(context).client;
    final userQuery = almanakProfile(profileId, client);

    return FutureWrapper(
      future: userQuery,
      success: showUserProfile,
    );
  }

  Widget showUserProfile(user) {
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

    return Scaffold(
      appBar: AppBar(
        title: Text(values.first),
        backgroundColor: Colors.lightBlue,
        shadowColor: Colors.transparent,
        systemOverlayStyle:
            const SystemUiOverlayStyle(statusBarColor: Colors.lightBlue),
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: ProfilePictureWidget(userId: user.identifier),
            ),
          ),
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
      ),
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

class ProfilePictureWidget extends StatelessWidget {
  const ProfilePictureWidget({
    Key? key,
    required this.userId,
  }) : super(key: key);

  final String userId;

  @override
  Widget build(BuildContext context) {
    const double profilePictureSize = 96;

    return FutureWrapper(
      future: getProfilePicture(userId),
      success: (Uint8List? data) => CircleAvatar(
        radius: profilePictureSize,
        backgroundImage: MemoryImage(data!),
      ),
      error: (error) => const CircleAvatar(
        radius: profilePictureSize,
        backgroundImage: AssetImage(Images.placeholderProfilePicture),
      ),
      loading: const ShimmerWidget(
        child: CircleAvatar(
          radius: profilePictureSize,
          backgroundImage: AssetImage(Images.placeholderProfilePicture),
        ),
      ),
    );
  }
}
