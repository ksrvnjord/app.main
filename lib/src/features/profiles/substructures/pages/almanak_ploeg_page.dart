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

    const yearSelectorPadding = 8.0;
    const double titleFontSize = 20;
    const double menuMaxHeight = 256;
    const double titleHPadding = 16;

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
        backgroundColor: Colors.lightBlue,
        shadowColor: Colors.transparent,
        systemOverlayStyle:
            const SystemUiOverlayStyle(statusBarColor: Colors.lightBlue),
      ),
      body: ListView(
        padding: const EdgeInsets.all(8),
        children: [
          [
            const Text("Leeden")
                .textColor(Colors.blueGrey)
                .fontSize(titleFontSize)
                .fontWeight(FontWeight.w500)
                .alignment(Alignment.centerLeft)
                .padding(horizontal: titleHPadding),
            if (selectedPloegType ==
                PloegType.wedstrijd) // for wedstrijd we need a year selector
              [
                const Text('Kies een jaar: ').textColor(Colors.blueGrey),
                DropdownButton<int>(
                  value: selectedYear,
                  icon:
                      const Icon(Icons.arrow_drop_down, color: Colors.blueGrey),
                  menuMaxHeight: menuMaxHeight,
                  items: years
                      .map(
                        (year) => DropdownMenuItem<int>(
                          value: year,
                          child: Text("$year-${year + 1}")
                              .textColor(Colors.blueGrey),
                        ),
                      )
                      .toList(),
                  onChanged: (value) =>
                      ref.read(ploegYearProvider.notifier).state = value!,
                ),
              ].toRow(),
          ].toRow(mainAxisAlignment: MainAxisAlignment.spaceBetween).padding(
                right: yearSelectorPadding,
              ),
          users.when(
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

  Widget buildCommissieList(QuerySnapshot<PloegEntry> snapshot) {
    List<QueryDocumentSnapshot<PloegEntry>> docs = snapshot.docs;
    docs.sort((a, b) => comparePloegFunctie(a.data(), b.data()));
    const double notFoundPadding = 16;

    return <Widget>[
      ...docs.map(
        (doc) => AlmanakUserTile(
          firstName: doc.data().firstName,
          lastName: doc.data().lastName,
          lidnummer: doc.data().identifier,
          subtitle: doc.data().role.value,
        ),
      ),
      if (docs.isEmpty)
        const Text("Geen Leeden gevonden voor deze ploeg gevonden")
            .textColor(Colors.grey)
            .center()
            .padding(all: notFoundPadding),
    ].toColumn();
  }

  int comparePloegFunctie(PloegEntry a, PloegEntry b) {
    // sort based on role in ploeg
    int iA = PloegRole.values.indexOf(a.role);
    int iB = PloegRole.values.indexOf(b.role);

    if (iA == iB) {
      // sort based on last name name
      return a.lastName.compareTo(b.lastName);
    } else {
      return iA.compareTo(iB);
    }
  }
}
