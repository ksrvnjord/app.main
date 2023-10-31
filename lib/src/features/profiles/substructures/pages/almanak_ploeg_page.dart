import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/edit_my_profile/api/wedstrijd_ploegen_provider.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/substructures/api/ploeg_users_provider.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/substructures/model/group_django_relation.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/widgets/almanak_user_tile.dart';
import 'package:ksrvnjord_main_app/src/features/shared/data/years_from_1874.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/error_card_widget.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:tuple/tuple.dart';

class AlmanakPloegPage extends ConsumerWidget {
  const AlmanakPloegPage({
    Key? key,
    required this.ploegName,
    required this.year,
  }) : super(key: key);

  final String ploegName;

  /// NOTE: year is nullable because it is optional in the route.
  final int year;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final users = ref.watch(ploegUsersProvider(Tuple2(ploegName, year)));

    const double menuMaxHeight = 256;
    const double headerHPadding = 16;

    final List<Tuple2<int, int>> years = yearsFrom1874;

    final ploegIsWedstrijdploeg =
        ref.watch(wedstrijdPloegenProvider).contains(ploegName);

    return Scaffold(
      appBar: AppBar(
        title: Text(ploegName),
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: [
              Text(
                "Leeden",
                style: Theme.of(context).textTheme.titleLarge,
              ).alignment(Alignment.centerLeft),
              [
                const Text('Kies een jaar: ').textColor(
                  ploegIsWedstrijdploeg ? null : Colors.grey,
                ),
                DropdownButton<int>(
                  items: years
                      .map((year) => DropdownMenuItem<int>(
                            value: year.item1,
                            child: Text("${year.item1}-${year.item2}"),
                          ))
                      .toList(),
                  value: year,
                  onChanged:
                      ploegIsWedstrijdploeg // Only wedstrijdploegen can have multiple years.
                          ? (value) => context.replaceNamed(
                                "Ploeg",
                                pathParameters: {"ploeg": ploegName},
                                queryParameters: {
                                  "year": (value ?? year).toString(),
                                },
                              )
                          : null,
                  icon: const Icon(Icons.arrow_drop_down),
                  menuMaxHeight: menuMaxHeight,
                ),
              ].toRow(),
            ].toRow(mainAxisAlignment: MainAxisAlignment.spaceBetween).padding(
                  horizontal: headerHPadding,
                ),
          ),
          SliverToBoxAdapter(
            child: users.when(
              data: (snapshot) => buildPloegList(snapshot),
              error: (error, stk) =>
                  ErrorCardWidget(errorMessage: error.toString()),
              loading: () => const Center(
                child: CircularProgressIndicator.adaptive(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildPloegList(List<GroupDjangoRelation> users) {
    users.sort((a, b) => comparePloegFunctie(a, b));
    const double notFoundPadding = 16;

    return <Widget>[
      ...users.map(
        (doc) => toListTile(doc),
      ),
      if (users.isEmpty)
        Text("Geen Leeden gevonden voor $ploegName")
            .center()
            .padding(all: notFoundPadding),
    ].toColumn();
  }

  AlmanakUserTile toListTile(GroupDjangoRelation relation) {
    final user = relation.user;

    return AlmanakUserTile(
      firstName: user.firstName,
      lastName: user.lastName,
      subtitle: relation.role,
      lidnummer: user.identifier.toString(),
    );
  }

  int comparePloegFunctie(GroupDjangoRelation a, GroupDjangoRelation b) {
    // Sort based on role in ploeg in the following order:
    final ploegRoles = [
      "coach",
      "stuur",
      "roeier",
    ];

    // Sort a and b based on their role in the ploeg.
    final aRole = ploegRoles.indexOf(a.role?.toLowerCase() ?? "");
    final bRole = ploegRoles.indexOf(b.role?.toLowerCase() ?? "");

    return aRole.compareTo(bRole);
  }
}
