import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ksrvnjord_main_app/src/features/admin/groups/groups_provider.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/api/group_id_provider.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/substructures/model/group_django_relation.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/widgets/almanak_user_tile.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/error_card_widget.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/year_selector_dropdown.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:tuple/tuple.dart';

class AlmanakPloegPage extends ConsumerWidget {
  const AlmanakPloegPage({
    super.key,
    required this.ploegOfficialName,
    required this.year,
    required this.name,
  });

  final String ploegOfficialName;

  /// NOTE: year is nullable because it is optional in the route.
  final int year;

  final String? name;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final groupId =
        ref.watch(groupIDProvider(Tuple2(ploegOfficialName, year))).valueOrNull;

    bool ploegIsWedstrijdploeg = false;
    String ploegName = (name != null) ? name! : "";
    final usersAsync =
        ref.watch(groupByIdStreamProvider(groupId)).whenData((ploegData) {
      ploegIsWedstrijdploeg = ploegData.type == "Wedstrijdsectie";
      ploegName = ploegName.isNotEmpty ? ploegName : ploegData.name;
      return ploegData.users ?? <GroupDjangoRelation>[];
    });

    const double headerHPadding = 16;

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
                YearSelectorDropdown(
                  onChanged:
                      ploegIsWedstrijdploeg // Only wedstrijdploegen can have multiple years.
                          ? (value) => context.replaceNamed(
                                "Ploeg",
                                pathParameters: {"name": ploegOfficialName},
                                queryParameters: {
                                  "year": (value ?? year).toString(),
                                },
                                extra: ploegName,
                              )
                          : null,
                  selectedYear: year,
                  officialName: ploegOfficialName,
                ),
              ].toRow(),
            ].toRow(mainAxisAlignment: MainAxisAlignment.spaceBetween).padding(
                  horizontal: headerHPadding,
                ),
          ),
          SliverToBoxAdapter(
            child: usersAsync.when(
              data: (users) => buildPloegList(users),
              error: (error, stk) => // TODO: handle groupId = null case
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
        Text("Geen Leeden gevonden voor ${name ?? ploegOfficialName}")
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
      lidnummer: user.iid.toString(),
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
