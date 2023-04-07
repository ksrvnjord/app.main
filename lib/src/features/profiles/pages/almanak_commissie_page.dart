import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/api/commissie_members.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/api/njord_year.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/api/substructure_picture_provider.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/data/substructuur_volgorde.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/pages/edit_my_profile/models/commissie_entry.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/widgets/almanak_substructure_cover_picture.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/widgets/almanak_user_tile.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/error_card_widget.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:tuple/tuple.dart';

final commissiesRef = FirebaseFirestore.instance
    .collectionGroup('commissies')
    .withConverter<CommissieEntry>(
      fromFirestore: (snapshot, _) => CommissieEntry.fromJson(snapshot.data()!),
      toFirestore: (almanakProfile, _) => almanakProfile.toJson(),
    );

class AlmanakCommissiePage extends ConsumerStatefulWidget {
  const AlmanakCommissiePage({
    Key? key,
    required this.commissieName,
  }) : super(key: key);

  final String commissieName;

  @override
  AlmanakCommissiePageState createState() => AlmanakCommissiePageState();
}

class AlmanakCommissiePageState extends ConsumerState<AlmanakCommissiePage> {
  Tuple2<int, int> selectedYear = Tuple2<int, int>(
    getNjordYear(),
    getNjordYear() + 1,
  );

  static const yearSelectorPadding = 8.0;

  @override
  Widget build(BuildContext context) {
    const int startYear = 1874;
    final List<Tuple2<int, int>> years = List.generate(
      DateTime.now().year - startYear,
      (index) => Tuple2<int, int>(
        // '2022-2023', '2021-2022', ...
        DateTime.now().year - index - 1,
        DateTime.now().year - index,
      ),
    ).toList();

    const double menuMaxHeight = 256;

    final Tuple2<String, int> commissieAndYear = Tuple2(
      widget.commissieName,
      selectedYear.item1,
    );

    final commissieLeeden = ref.watch(
      commissieLeedenProvider(commissieAndYear),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.commissieName),
        backgroundColor: Colors.lightBlue,
        shadowColor: Colors.transparent,
        systemOverlayStyle:
            const SystemUiOverlayStyle(statusBarColor: Colors.lightBlue),
      ),
      body: ListView(
        children: [
          AlmanakSubstructureCoverPicture(
            imageProvider:
                ref.watch(commissiePictureProvider(commissieAndYear)),
          ),
          [
            [
              const Text('Kies een jaar: ').textColor(Colors.blueGrey),
              DropdownButton<Tuple2<int, int>>(
                value: selectedYear,
                icon: const Icon(Icons.arrow_drop_down, color: Colors.blueGrey),
                menuMaxHeight: menuMaxHeight,
                items: years
                    .map(
                      (year) => DropdownMenuItem<Tuple2<int, int>>(
                        value: year,
                        child: Text("${year.item1}-${year.item2}")
                            .textColor(Colors.blueGrey),
                      ),
                    )
                    .toList(),
                onChanged: (tuple) => setState(() {
                  selectedYear = tuple!;
                }),
              ),
            ].toRow(mainAxisAlignment: MainAxisAlignment.end),
          ].toColumn().padding(
                right: yearSelectorPadding,
              ),
          commissieLeeden.when(
            data: (snapshot) => buildCommissieList(snapshot),
            error: (error, stk) =>
                ErrorCardWidget(errorMessage: error.toString()),
            loading: () => const Center(
              child: CircularProgressIndicator(),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildCommissieList(QuerySnapshot<CommissieEntry> snapshot) {
    List<QueryDocumentSnapshot<CommissieEntry>> docs = snapshot.docs;
    docs.sort((a, b) => compareCommissieFunctie(a.data(), b.data()));
    const double notFoundPadding = 16;

    return <Widget>[
      ...docs.map(
        (doc) => AlmanakUserTile(
          firstName: doc.data().firstName,
          lastName: doc.data().lastName,
          lidnummer: doc.data().lidnummer,
          subtitle: doc.data().function ?? "",
        ),
      ),
      if (docs.isEmpty)
        const Text("Geen Leeden gevonden voor deze commissie in dit jaar")
            .textColor(Colors.grey)
            .center()
            .padding(all: notFoundPadding),
    ].toColumn();
  }

  /// Compare the bestuursfuncties op basis van constitutie
  int compareCommissieFunctie(CommissieEntry a, CommissieEntry b) {
    int aPos = substructuurVolgorde.indexOf(a.function ?? "");
    int bPos = substructuurVolgorde.indexOf(b.function ?? "");
    // Order the ones that are not in the list at the end
    if (aPos == -1) aPos = substructuurVolgorde.length;
    if (bPos == -1) bPos = substructuurVolgorde.length;

    return aPos.compareTo(bPos);
  }
}
