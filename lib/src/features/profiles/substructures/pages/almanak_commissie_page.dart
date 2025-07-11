import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/api/group_id_provider.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/api/commissie_members.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/api/substructure_picture_provider.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/data/substructuur_volgorde.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/substructures/api/commissie_info_provider.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/substructures/model/group_django_relation.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/substructures/widgets/almanak_substructure_cover_picture.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/substructures/widgets/substructure_description_widget.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/substructures/api/user_permission_provider.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/widgets/almanak_user_tile.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/error_card_widget.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/year_selector_dropdown.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:tuple/tuple.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/api/user_provider.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

class AlmanakCommissiePage extends ConsumerStatefulWidget {
  const AlmanakCommissiePage({
    super.key,
    required this.name,
    required this.year,
  });

  final String name;
  final int year;

  @override
  AlmanakCommissiePageState createState() => AlmanakCommissiePageState();
}

class AlmanakCommissiePageState extends ConsumerState<AlmanakCommissiePage> {
  static const yearSelectorPadding = 8.0;
  static const double titleHPadding = 16;

  final ScrollController scrollController = ScrollController(
    keepScrollOffset: true,
  ); // For keeping scroll position when changing year.

  @override
  Widget build(BuildContext context) {
    final commissieAndYear = Tuple2(
      widget.name,
      widget.year,
    );
    final groupIdAsync = ref.watch(groupIDProvider(commissieAndYear));

    final commissieLeeden = ref.watch(
      commissieLeedenProvider(commissieAndYear),
    );

    final currentUserVal = ref.watch(currentUserProvider);
    final colorScheme = Theme.of(context).colorScheme;

    const double pageHPadding = 12;
    const double descriptionHPadding = pageHPadding + 4;
    return groupIdAsync.when(
      data: (groupId) {
        final commissieIdAndName =
            Tuple3(widget.name, widget.year, groupId ?? 0);
        return Scaffold(
          appBar: AppBar(
            title: Text(widget.name),
          ),
          body: ListView(
            controller:
                scrollController, // For keeping scroll position when changing year.
            physics: const AlwaysScrollableScrollPhysics(),
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(12)),
                child: AlmanakSubstructureCoverPicture(
                  imageProvider:
                      ref.watch(commissiePictureProvider(commissieIdAndName)),
                ),
              ).padding(horizontal: pageHPadding),
              SubstructureDescriptionWidget(
                descriptionAsyncVal: ref.watch(
                  commissieDescriptionProvider(commissieIdAndName),
                ),
              ).padding(all: descriptionHPadding),
              [
                Text(
                  "Leeden",
                  style: Theme.of(context).textTheme.titleLarge,
                )
                    .alignment(Alignment.centerLeft)
                    .padding(horizontal: titleHPadding),
                [
                  const Text('Kies een jaar: '),
                  YearSelectorDropdown(
                    onChanged: (y) => context.goNamed(
                      "Commissie",
                      pathParameters: {
                        "name": widget.name,
                      },
                      queryParameters: {
                        "year": y.toString(),
                      },
                    ),
                    selectedYear: widget.year,
                  ),
                ].toRow(),
              ]
                  .toRow(mainAxisAlignment: MainAxisAlignment.spaceBetween)
                  .padding(
                    right: yearSelectorPadding,
                  ),
              commissieLeeden.when(
                data: (snapshot) => buildCommissieList(snapshot),
                error: (error, stk) =>
                    ErrorCardWidget(errorMessage: error.toString()),
                loading: () => const Center(
                  child: CircularProgressIndicator.adaptive(),
                ),
              ),
            ],
          ),
          floatingActionButton: currentUserVal.when(
            data: (currentUser) {
              final groupIdAsync = ref.watch(groupIDProvider(commissieAndYear));
              return groupIdAsync.when(
                data: (groupId) {
                  final userId = currentUser.identifier;
                  if (groupId == null) return const SizedBox.shrink();
                  final permissionsAsync =
                      ref.watch(permissionsProvider(Tuple2(groupId, userId)));

                  return permissionsAsync.when(
                    data: (permissions) {
                      final canAccessEditGroupPage = currentUser.isAdmin ||
                          permissions.contains("almanak:*");
                      if (!canAccessEditGroupPage) return null;
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          FloatingActionButton.extended(
                            heroTag: "Commissie -> Edit",
                            foregroundColor: colorScheme.onTertiaryContainer,
                            backgroundColor: colorScheme.tertiaryContainer,
                            onPressed: () {
                              context.goNamed(
                                "Commissie -> Edit",
                                pathParameters: {
                                  "name": widget.name,
                                },
                                queryParameters: {
                                  "year": widget.year.toString(),
                                  "groupId": groupId.toString(),
                                },
                              );
                            },
                            icon: const Icon(Icons.edit_outlined),
                            label: const Text('Edit'),
                          ),
                          const SizedBox(height: 12),
                          if (widget.name.toLowerCase() == "almanakcommissie")
                            FloatingActionButton.extended(
                              heroTag: 'profielfoto\'s downloaden',
                              foregroundColor: colorScheme.onPrimaryContainer,
                              backgroundColor: colorScheme.primaryContainer,
                              onPressed: () {
                                context.goNamed(
                                  "download profile pictures",
                                  pathParameters: {
                                    "name": widget.name,
                                  },
                                );
                              },
                              icon: const Icon(Icons.download),
                              label: Text("download profile pictures"),
                            ),
                        ],
                      );
                    },
                    loading: () => null,
                    error: (e, s) => const SizedBox.shrink(),
                  );
                },
                error: (error, stack) {
                  FirebaseCrashlytics.instance.recordError(error, stack);
                  return const SizedBox.shrink();
                },
                loading: () => null,
              );
            },
            error: (e, s) {
              debugPrint("Error message when retrieving permission: $e");
              return null;
            },
            loading: () => const SizedBox.shrink(),
          ),
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (e, s) => const SizedBox.shrink(),
    );
  }

  Widget buildCommissieList(List<GroupDjangoRelation> entries) {
    entries.sort((a, b) => compareCommissieFunctie(a, b));
    const double notFoundPadding = 16;

    return <Widget>[
      ...entries.map(
        (doc) => toListTile(doc),
      ),
      if (entries.isEmpty)
        const Text("Geen Leeden gevonden voor deze commissie in dit jaar")
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

  /// Compare the bestuursfuncties op basis van constitutie.
  int compareCommissieFunctie(GroupDjangoRelation a, GroupDjangoRelation b) {
    int aPos = substructuurVolgorde.indexOf(a.role ?? "");
    int bPos = substructuurVolgorde.indexOf(b.role ?? "");
    // Order the ones that are not in the list at the end.
    if (aPos == -1) aPos = substructuurVolgorde.length;
    if (bPos == -1) bPos = substructuurVolgorde.length;

    return aPos.compareTo(bPos);
  }
}
