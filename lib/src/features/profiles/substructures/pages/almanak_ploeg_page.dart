import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/api/njord_year.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/choice/providers/ploeg_type_provider.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/choice/providers/ploeg_year_provider.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/edit_my_profile/models/ploeg_entry.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/substructures/api/ploeg_users_provider.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/widgets/almanak_user_tile.dart';
import 'package:ksrvnjord_main_app/src/features/shared/data/years_from_1874.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/error_card_widget.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:tuple/tuple.dart';

class AlmanakPloegPage extends ConsumerWidget {
  const AlmanakPloegPage({
    Key? key,
    required this.ploegName,
  }) : super(key: key);

  final String ploegName;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final users = ref.watch(ploegUsersProvider(ploegName));
    final selectedYear = ref.watch(ploegYearProvider);
    final selectedPloegType = ref.watch(ploegTypeProvider);

    const double menuMaxHeight = 256;
    const double headerHPadding = 16;

    final List<Tuple2<int, int>> years = yearsFrom1874;

    return Scaffold(
      appBar: AppBar(
        title: Text(ploegName),
      ),
      body: ListView(
        padding: const EdgeInsets.only(bottom: 80),
        children: [
          [
            Text(
              "Leeden",
              style: Theme.of(context).textTheme.titleLarge,
            ).alignment(Alignment.centerLeft),
            [
              const Text('Kies een jaar: ').textColor(
                selectedPloegType == PloegType.wedstrijd ? null : Colors.grey,
              ),
              DropdownButton<int>(
                items: years
                    .map((year) => DropdownMenuItem<int>(
                          value: year.item1,
                          child: Text("${year.item1}-${year.item2}"),
                        ))
                    .toList(),
                value: selectedYear,
                onChanged: selectedPloegType == PloegType.wedstrijd
                    ? (value) => ref.read(ploegYearProvider.notifier).state =
                        value ?? getNjordYear()
                    : null,
                icon: const Icon(Icons.arrow_drop_down),
                menuMaxHeight: menuMaxHeight,
              ),
            ].toRow(),
          ].toRow(mainAxisAlignment: MainAxisAlignment.spaceBetween).padding(
                horizontal: headerHPadding,
              ),
          users.when(
            data: (snapshot) => buildPloegList(snapshot),
            error: (error, stk) =>
                ErrorCardWidget(errorMessage: error.toString()),
            loading: () => const Center(
              child: CircularProgressIndicator.adaptive(),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildPloegList(QuerySnapshot<PloegEntry> snapshot) {
    List<QueryDocumentSnapshot<PloegEntry>> docs = snapshot.docs;
    docs.sort((a, b) => comparePloegFunctie(a.data(), b.data()));
    const double notFoundPadding = 16;

    return <Widget>[
      ...docs.map(
        (doc) => toListTile(doc),
      ),
      if (docs.isEmpty)
        Text("Geen Leeden gevonden voor $ploegName")
            .center()
            .padding(all: notFoundPadding),
    ].toColumn();
  }

  AlmanakUserTile toListTile(QueryDocumentSnapshot<PloegEntry> doc) {
    final user = doc.data();

    return AlmanakUserTile(
      firstName: user.firstName,
      lastName: user.lastName,
      subtitle: user.role.value,
      lidnummer: user.identifier,
    );
  }

  int comparePloegFunctie(PloegEntry a, PloegEntry b) {
    // Sort based on role in ploeg.
    int indexA = PloegRole.values.indexOf(a.role);
    int indexB = PloegRole.values.indexOf(b.role);

    return indexA == indexB
        ? a.lastName.compareTo(b.lastName)
        : indexA.compareTo(indexB);
  }
}
