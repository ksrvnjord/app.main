import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/choice/providers/ploeg_type_provider.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/choice/providers/ploeg_year_provider.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/edit_my_profile/models/ploeg_entry.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/substructures/api/ploeg_users_provider.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/widgets/almanak_user_tile.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/error_card_widget.dart';
import 'package:styled_widget/styled_widget.dart';

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

    const double titleFontSize = 20;
    const double menuMaxHeight = 256;
    const double headerHPadding = 16;

    const int startYear = 1874;
    final List<int> years = List.generate(
      DateTime.now().year - startYear,
      (index) =>
          // '2022-2023', '2021-2022', ...
          DateTime.now().year - index - 1,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(ploegName),
        shadowColor: Colors.transparent,
        backgroundColor: Colors.lightBlue,
        systemOverlayStyle:
            const SystemUiOverlayStyle(statusBarColor: Colors.lightBlue),
      ),
      body: ListView(
        padding: const EdgeInsets.only(bottom: 80),
        children: [
          [
            const Text("Leeden")
                .textColor(Colors.blueGrey)
                .fontSize(titleFontSize)
                .fontWeight(FontWeight.w500)
                .alignment(Alignment.centerLeft),
            [
              const Text('Kies een jaar: ').textColor(
                selectedPloegType == PloegType.wedstrijd
                    ? Colors.blueGrey
                    : Colors.grey,
              ),
              DropdownButton<int>(
                items: years
                    .map((year) => DropdownMenuItem<int>(
                          value: year,
                          child: Text("$year-${year + 1}"),
                        ))
                    .toList(),
                value: selectedYear,
                onChanged: selectedPloegType == PloegType.wedstrijd
                    ? (value) =>
                        ref.read(ploegYearProvider.notifier).state = value!
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
              child: CircularProgressIndicator(),
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
        Text("Geen Leeden gevonden voor $ploegName gevonden")
            .textColor(Colors.grey)
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
