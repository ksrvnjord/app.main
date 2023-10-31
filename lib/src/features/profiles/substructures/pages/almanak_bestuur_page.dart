import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/api/bestuur_picture_provider.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/api/bestuur_users.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/api/njord_year.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/models/firestore_user.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/substructures/widgets/almanak_substructure_cover_picture.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/widgets/almanak_user_tile.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/error_card_widget.dart';
import 'package:styled_widget/styled_widget.dart';

class AlmanakBestuurPage extends ConsumerWidget {
  const AlmanakBestuurPage({Key? key}) : super(key: key);

  static const imageAspectRatio = 3 / 6;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bestuur = ref.watch(bestuurUsersProvider);

    const double pageHPadding = 12;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Bestuur"),
      ),
      body: ListView(
        padding: const EdgeInsets.only(bottom: 80),
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(12)),
            child: AlmanakSubstructureCoverPicture(
              imageProvider: ref.watch(bestuurPictureProvider(getNjordYear())),
            ),
          ).padding(horizontal: pageHPadding),
          bestuur.when(
            data: (snapshot) => buildBestuurList(snapshot),
            loading: () => const CircularProgressIndicator.adaptive().center(),
            error: (error, stack) => ErrorCardWidget(
              errorMessage: error.toString(),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildBestuurList(QuerySnapshot<FirestoreUser> snapshot) {
    List<QueryDocumentSnapshot<FirestoreUser>> docs = snapshot.docs;
    // We want to sort baseed on the bestuurs_volgorde.
    docs.sort((a, b) => compareBestuursFunctie(a.data(), b.data()));

    return <Widget>[
      ...docs.map(
        (doc) => toListTile(doc),
      ),
    ].toColumn();
  }

  AlmanakUserTile toListTile(
    QueryDocumentSnapshot<FirestoreUser> doc,
  ) {
    final user = doc.data();

    return AlmanakUserTile(
      firstName: user.firstName,
      lastName: user.lastName,
      subtitle: user.bestuursFunctie,
      lidnummer: user.identifier,
    );
  }

  /// Compare the bestuursfuncties op basis van constitutie.
  int compareBestuursFunctie(
    FirestoreUser a,
    FirestoreUser b,
  ) {
    const List<String> bestuurVolgorde = [
      "Praeses",
      "Ab-actis en Commissaris voor Oud-Njord",
      "Quaestor",
      "Commissaris voor het Wedstrijdroeien",
      "Commissaris van het Materieel",
      "Commissaris van de Gebouwen",
      "Commissaris van het Buffet",
      "Commissaris voor het Competitie- en Fuifroeien",
      "Commissaris voor Externe Betrekkingen",
      "Oprichter der K.S.R.V. \"Njord\"",
    ];

    return bestuurVolgorde
        .indexOf(a.bestuursFunctie ?? "")
        .compareTo(bestuurVolgorde.indexOf(b.bestuursFunctie ?? ""));
  }
}
