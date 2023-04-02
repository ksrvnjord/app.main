import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/api/home_users.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/models/almanak_profile.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/widgets/almanak_user_tile.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/error_card_widget.dart';
import 'package:styled_widget/styled_widget.dart';

class AlmanakHuisPage extends ConsumerWidget {
  const AlmanakHuisPage({
    Key? key,
    required this.houseName,
  }) : super(key: key);

  final String houseName;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final users = ref.watch(homeUsers(houseName));

    return Scaffold(
      appBar: AppBar(
        title: Text(houseName),
        backgroundColor: Colors.lightBlue,
        shadowColor: Colors.transparent,
        systemOverlayStyle:
            const SystemUiOverlayStyle(statusBarColor: Colors.lightBlue),
      ),
      body: ListView(
        padding: const EdgeInsets.all(8),
        children: [
          users.when(
            data: (snapshot) => buildHuisList(snapshot),
            loading: () => const CircularProgressIndicator().center(),
            error: (error, stack) => ErrorCardWidget(
              errorMessage: error.toString(),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildHuisList(QuerySnapshot<AlmanakProfile> snapshot) {
    List<QueryDocumentSnapshot<AlmanakProfile>> docs = snapshot.docs;
    const double notFoundPadding = 16;

    return <Widget>[
      ...docs.map(
        (doc) => AlmanakUserTile(
          firstName: doc.data().firstName!,
          lastName: doc.data().lastName!,
          lidnummer: doc.data().lidnummer,
        ),
      ),
      if (docs.isEmpty)
        const Text("Geen Leeden gevonden voor dit huis")
            .textColor(Colors.grey)
            .center()
            .padding(all: notFoundPadding),
    ].toColumn();
  }
}
