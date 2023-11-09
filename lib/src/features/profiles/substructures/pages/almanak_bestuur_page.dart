import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/api/bestuur_picture_provider.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/api/bestuur_users.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/substructures/model/group_django_relation.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/substructures/widgets/almanak_substructure_cover_picture.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/widgets/almanak_user_tile.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/error_card_widget.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/year_selector_dropdown.dart';
import 'package:styled_widget/styled_widget.dart';

class AlmanakBestuurPage extends ConsumerWidget {
  const AlmanakBestuurPage({Key? key, required this.year}) : super(key: key);

  final int year;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bestuurVal = ref.watch(bestuurUsersProvider(year));

    const yearSelectorPadding = 8.0;

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
              imageProvider: ref.watch(bestuurPictureProvider(year)),
            ),
          ).padding(horizontal: pageHPadding),
          [
            Text(
              "Leeden",
              style: Theme.of(context).textTheme.titleLarge,
            ).alignment(Alignment.centerLeft).padding(horizontal: pageHPadding),
            [
              const Text('Kies een jaar: '),
              YearSelectorDropdown(
                onChanged: (y) => context.goNamed(
                  "Bestuur",
                  queryParameters: {
                    "year": y.toString(),
                  },
                ),
                selectedYear: year,
              ),
            ].toRow(),
          ].toRow(mainAxisAlignment: MainAxisAlignment.spaceBetween).padding(
                right: yearSelectorPadding,
              ),
          bestuurVal.when(
            data: (bestuur) {
              final users = bestuur?.users;

              return bestuur == null || users == null
                  ? const Text(
                      "Er zijn geen bestuursleden gevonden voor dit jaar.",
                    ).center()
                  : buildBestuurList(users);
            },
            loading: () => const CircularProgressIndicator.adaptive().center(),
            error: (error, stack) => ErrorCardWidget(
              errorMessage: error.toString(),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildBestuurList(List<GroupDjangoRelation> users) {
    // We want to sort baseed on the bestuurs_volgorde.
    users.sort((a, b) => compareBestuursFunctie(a.role, b.role));

    return <Widget>[
      ...users.map(
        (user) => toListTile(user),
      ),
    ].toColumn();
  }

  AlmanakUserTile toListTile(
    GroupDjangoRelation groupRelation,
  ) {
    return AlmanakUserTile(
      firstName: groupRelation.user.firstName,
      lastName: groupRelation.user.lastName,
      subtitle: groupRelation.role,
      lidnummer: groupRelation.user.identifier.toString(),
    );
  }

  /// Compare the bestuursfuncties op basis van constitutie.
  int compareBestuursFunctie(
    String? roleA,
    String? roleB,
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
        .indexOf(roleA ?? "")
        .compareTo(bestuurVolgorde.indexOf(roleB ?? ""));
  }
}
