import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/models/profile.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/widgets/almanak_profile_bottomsheet_widget.dart';
import 'package:ksrvnjord_main_app/src/features/shared/model/graphql_model.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/future_wrapper.dart';
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
        success: (user) {
          if (user != null) {
            final contact = user.fullContact.public;

            const List<String> labels = [
              'Naam',
              'Telefoonnummer',
              'E-mailadres',
              'Adres',
              'Postcode',
              'Woonplaats'
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

            return Scaffold(
                appBar: AppBar(
                  title: Text(values[0]),
                  backgroundColor: Colors.lightBlue,
                  shadowColor: Colors.transparent,
                  systemOverlayStyle: const SystemUiOverlayStyle(
                      statusBarColor: Colors.lightBlue),
                ),
                body: SizedBox(
                    child: ListView.builder(
                        physics: const PageScrollPhysics(),
                        itemCount: labels.length,
                        itemBuilder: (BuildContext context, int index) {
                          if (values[index] != '') {
                            return GestureDetector(
                              child: TextFormField(
                                enabled: false,
                                decoration: InputDecoration(
                                  labelText: labels[index],
                                  border: const OutlineInputBorder(),
                                ),
                                initialValue: values[index],
                              ).padding(all: 15),
                              onLongPress: () {
                                HapticFeedback.vibrate();
                                showModalBottomSheet(
                                    context: context,
                                    builder: (_) =>
                                        AlmanakProfileBottomsheetWidget(
                                            label: labels[index],
                                            value: values[index]));
                              },
                            );
                          } else {
                            return Container();
                          }
                        })));
          }

          return null;
        });
  }
}
