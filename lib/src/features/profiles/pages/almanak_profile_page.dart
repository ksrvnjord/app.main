import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/models/profile.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/widgets/profile_picture_widget.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/error_card_widget.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/future_wrapper.dart';
import 'package:provider/provider.dart';
import 'package:routemaster/routemaster.dart';
import 'package:styled_widget/styled_widget.dart';

import '../../shared/model/graphql_model.dart';
import '../widgets/almanak_profile_bottomsheet_widget.dart';

class AlmanakProfilePage extends StatelessWidget {
  const AlmanakProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Map<String, String> params = RouteData.of(context).pathParameters;
    if (params['profileId'] == null) {
      return const ErrorCardWidget(errorMessage: 'Geen profiel gevonden');
    }
    String profileId = params['profileId']!;
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
