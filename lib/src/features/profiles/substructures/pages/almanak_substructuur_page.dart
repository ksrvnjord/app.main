import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/api/substructure_picture_provider.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/api/substructure_users.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/models/almanak_profile.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/substructures/api/substructure_info_provider.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/substructures/widgets/almanak_substructure_cover_picture.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/widgets/almanak_user_tile.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/error_card_widget.dart';
import 'package:styled_widget/styled_widget.dart';

class AlmanakSubstructuurPage extends ConsumerWidget {
  const AlmanakSubstructuurPage({
    Key? key,
    required this.name,
  }) : super(key: key);

  final String name;
  static const widgetPadding = 16.0;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final substructureUsers = ref.watch(substructureUsersProvider(name));
    final description = ref.watch(substructureDescriptionProvider(name));

    return Scaffold(
      appBar: AppBar(
        title: Text(name),
        backgroundColor: Colors.lightBlue,
        shadowColor: Colors.transparent,
        systemOverlayStyle:
            const SystemUiOverlayStyle(statusBarColor: Colors.lightBlue),
      ),
      body: ListView(
        children: [
          AlmanakSubstructureCoverPicture(
            imageProvider: ref.watch(substructurePictureProvider(name)),
          ),
          description.when(
            data: (data) => data == null
                ? const SizedBox.shrink()
                : [
                    Text(data).textColor(Colors.blueGrey).expanded(flex: 0),
                  ].toColumn().padding(all: widgetPadding),
            loading: () => const CircularProgressIndicator().center(),
            error: (error, stack) => ErrorCardWidget(
              errorMessage: error.toString(),
            ),
          ),
          substructureUsers.when(
            data: (snapshot) => buildSubstructuurList(snapshot),
            loading: () => const CircularProgressIndicator().center(),
            error: (error, stack) => ErrorCardWidget(
              errorMessage: error.toString(),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildSubstructuurList(QuerySnapshot<AlmanakProfile> snapshot) {
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
        const Text("Geen Leeden gevonden voor deze substructuur")
            .textColor(Colors.grey)
            .center()
            .padding(all: notFoundPadding),
    ].toColumn();
  }
}
