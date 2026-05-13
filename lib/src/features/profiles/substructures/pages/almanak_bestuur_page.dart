import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ksrvnjord_main_app/src/features/admin/groups/groups_provider.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/api/bestuur_picture_provider.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/api/user_provider.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/substructures/api/user_permission_provider.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/substructures/model/group_django_relation.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/substructures/widgets/almanak_substructure_cover_picture.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/widgets/almanak_user_tile.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/error_card_widget.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/year_selector_dropdown.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:tuple/tuple.dart';

class AlmanakBestuurPage extends ConsumerWidget {
  const AlmanakBestuurPage({super.key, required this.year});

  final int year;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUserVal = ref.watch(currentUserProvider);

    final groupsAsync =
        ref.watch(allGroupsByYearProvider(Tuple2("bestuur", year)));
    final groupId = groupsAsync.valueOrNull?.firstOrNull?.id;

    final bestuursLeedenVal = ref
        .watch(groupByIdStreamProvider(groupId))
        .whenData((ploeg) => ploeg.users ?? <GroupDjangoRelation>[]);

    final colorScheme = Theme.of(context).colorScheme;
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
                isBestuurPage: true,
              ),
            ).padding(horizontal: pageHPadding),
            [
              Text(
                "Leeden",
                style: Theme.of(context).textTheme.titleLarge,
              )
                  .alignment(Alignment.centerLeft)
                  .padding(horizontal: pageHPadding),
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
            bestuursLeedenVal.when(
              data: (users) {
                return users.isEmpty
                    ? const Text(
                        "Er zijn geen bestuursleden gevonden voor dit jaar.",
                      ).center()
                    : buildBestuurList(users);
              },
              loading: () =>
                  const CircularProgressIndicator.adaptive().center(),
              error: (error, stack) => ErrorCardWidget(
                errorMessage: error.toString(),
              ),
            ),
          ],
        ),
        floatingActionButton: currentUserVal.when(
          data: (currentUser) {
            if (groupId == null) return SizedBox.shrink();
            final userId = currentUser.identifier;
            final permissionsAsync =
                ref.watch(permissionsProvider(Tuple2(groupId, userId)));

            return permissionsAsync.when(
                data: (permissions) {
                  final canAccessEditGroupPage =
                      currentUser.isAdmin || permissions.contains("almanak:*");
                  if (!canAccessEditGroupPage) return null;
                  return Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        FloatingActionButton.extended(
                          heroTag: "Bestuur -> Edit",
                          foregroundColor: colorScheme.onTertiaryContainer,
                          backgroundColor: colorScheme.tertiaryContainer,
                          onPressed: () {
                            context.goNamed(
                              "Bestuur -> Edit",
                              queryParameters: {
                                "year": year.toString(),
                              },
                            );
                          },
                          icon: const Icon(Icons.edit_outlined),
                          label: const Text('Edit'),
                        ),
                      ]);
                },
                error: (e, s) => const SizedBox.shrink(),
                loading: () => null);
          },
          error: (e, s) => const SizedBox.shrink(),
          loading: () => null,
        ));
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
      lidnummer: groupRelation.user.iid.toString(),
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
