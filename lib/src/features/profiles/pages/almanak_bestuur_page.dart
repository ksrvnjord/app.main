import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/api/bestuur_picture_provider.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/api/bestuur_users.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/api/njord_year.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/data/bestuurs_volgorde.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/models/almanak_profile.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/widgets/almanak_substructure_cover_picture.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/widgets/almanak_user_tile.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/error_card_widget.dart';
import 'package:styled_widget/styled_widget.dart';

class AlmanakBestuurPage extends ConsumerWidget {
  const AlmanakBestuurPage({Key? key}) : super(key: key);

  static const imageAspectRatio = 3 / 6;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bestuur = ref.watch(bestuurUsersProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Bestuur"),
        backgroundColor: Colors.lightBlue,
        shadowColor: Colors.transparent,
        systemOverlayStyle:
            const SystemUiOverlayStyle(statusBarColor: Colors.lightBlue),
      ),
      body: ListView(
        children: [
          AlmanakSubstructureCoverPicture(
            imageProvider: ref.watch(bestuurPictureProvider(getNjordYear())),
          ),
          bestuur.when(
            data: (snapshot) => buildBestuurList(snapshot),
            loading: () => const CircularProgressIndicator().center(),
            error: (error, stack) => ErrorCardWidget(
              errorMessage: error.toString(),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildBestuurList(QuerySnapshot<AlmanakProfile> snapshot) {
    List<QueryDocumentSnapshot<AlmanakProfile>> docs = snapshot.docs;
    // we want to sort baseed on the bestuurs_volgorde
    docs.sort((a, b) => compareBestuursFunctie(a.data(), b.data()));

    return <Widget>[
      ...docs.map(
        (doc) => AlmanakUserTile(
          firstName: doc.data().firstName!,
          lastName: doc.data().lastName!,
          subtitle: doc.data().bestuursFunctie!,
          lidnummer: doc.data().lidnummer,
        ),
      ),
    ].toColumn();
  }

  /// Compare the bestuursfuncties op basis van constitutie
  int compareBestuursFunctie(AlmanakProfile a, AlmanakProfile b) =>
      bestuurVolgorde
          .indexOf(a.bestuursFunctie!)
          .compareTo(bestuurVolgorde.indexOf(b.bestuursFunctie!));
}
