import 'package:flutter/material.dart';
import 'package:graphql/client.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ksrvnjord_main_app/providers/heimdall.dart';
import 'package:ksrvnjord_main_app/queries/queries/change_visibility.dart'
    as query;
import 'package:ksrvnjord_main_app/widgets/me/visibility/change_visibility_dialog_content.dart';
import 'package:ksrvnjord_main_app/widgets/ui/general/loading.dart';

void showChangeVisibilityDialog(context) {
  showDialog(
      barrierDismissible: true,
      barrierColor: null,
      context: context,
      builder: (BuildContext context) => const ChangeVisibilityDialog());
}

class ChangeVisibilityDialog extends HookConsumerWidget {
  const ChangeVisibilityDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final GraphQLClient client = ref.watch(heimdallProvider).graphQLClient();
    final QueryOptions options =
        QueryOptions(document: gql(query.changeVisibilityQuery));
    final Future<QueryResult> result = client.query(options);

    return AlertDialog(
        insetPadding: const EdgeInsets.all(17),
        title: const Text('Aanpassen zichtbaarheid almanak'),
        content: FutureBuilder(
            future: result,
            builder:
                (BuildContext context, AsyncSnapshot<QueryResult> snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                  return const Loading();
                case ConnectionState.waiting:
                  return const Loading();
                default:
                  if (snapshot.hasError) {
                    return const Loading();
                  }
                  Map<String, dynamic> userPublic =
                      snapshot.data?.data!['me']['fullContact']['public'];

                  bool listed = false;

                  Map<String, bool> initialSettings =
                      userPublic.map(((key, value) {
                    value = (value == null ? false : true);
                    return MapEntry(key, value);
                  }));
                  Map<String, bool> changedSettings = Map.from(initialSettings);

                  List<Map<String, dynamic>> labels = [
                    {
                      'backend': 'first_name',
                      'display': 'Voornaam',
                      'is_amendable': false
                    },
                    {
                      'backend': 'last_name',
                      'display': 'Achternaam',
                      'is_amendable': false
                    },
                    {
                      'backend': 'email',
                      'display': 'E-mailadres',
                      'is_amendable': true
                    },
                    {
                      'backend': 'phone_primary',
                      'display': 'Telefoonnummer',
                      'is_amendable': true
                    },
                    {
                      'backend': 'street',
                      'display': 'Straatnaam',
                      'is_amendable': true
                    },
                    {
                      'backend': 'housenumber',
                      'display': 'Huisnmr',
                      'is_amendable': true
                    },
                    {
                      'backend': 'housenumber_addition',
                      'display': 'Toevoeging',
                      'is_amendable': true
                    },
                    {
                      'backend': 'zipcode',
                      'display': 'Postcode',
                      'is_amendable': true
                    },
                    {
                      'backend': 'city',
                      'display': 'Stad',
                      'is_amendable': true
                    },
                  ];
                  return ChangeVisibilityDialogContent(
                      listed, labels, initialSettings, changedSettings);
              }
            }));
  }
}
