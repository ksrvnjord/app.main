import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/api/group_id_provider.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/api/group_utils.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/api/substructure_picture_provider.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/data/substructuur_volgorde.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/substructures/api/commissie_info_provider.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/substructures/model/group_django_relation.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/substructures/widgets/almanak_substructure_cover_picture.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/substructures/widgets/substructure_description_widget.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/substructures/api/user_permission_provider.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/widgets/almanak_user_tile.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/error_card_widget.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/error_text_widget.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/year_selector_dropdown.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:tuple/tuple.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/api/user_provider.dart';

class AlmanakCommissiePage extends ConsumerStatefulWidget {
  const AlmanakCommissiePage(
      {super.key, required this.officialName, required this.year, this.name});

  final String officialName;
  final int year;
  final String? name;

  @override
  AlmanakCommissiePageState createState() => AlmanakCommissiePageState();
}

class AlmanakCommissiePageState extends ConsumerState<AlmanakCommissiePage> {
  static const yearSelectorPadding = 8.0;
  static const double titleHPadding = 16;

  final ScrollController scrollController = ScrollController(
    keepScrollOffset: true,
  ); // For keeping scroll position when changing year.

  _nameVal({
    required AsyncValue<String> commissieNameAsync,
  }) {
    if (widget.name != null) return Text(widget.name!);

    return commissieNameAsync.when(
      data: (name) => Text(name),
      error: (error, stackTrace) =>
          ErrorTextWidget(errorMessage: error.toString()),
      loading: () => const SizedBox.shrink(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final officialName = widget.officialName;
    final year = widget.year;
    final commissieAndYear = Tuple2(
      officialName,
      year,
    );
    final groupIdAsync = ref.watch(groupIDProvider(commissieAndYear));

    final currentUserVal = ref.watch(currentUserProvider);
    final colorScheme = Theme.of(context).colorScheme;

    const double pageHPadding = 12;
    const double descriptionHPadding = pageHPadding + 4;
    return groupIdAsync.when(
      data: (groupId) {
        final commissieLeedenAsync = ref.watch(
          groupLeedenProvider(groupId ?? 0),
        );

        final commissieNameAsync = ref.watch(
          groupNameProvider(groupId ?? 0),
        );

        final commissieIdAndName = Tuple3(officialName, year, groupId ?? 0);
        return Scaffold(
          appBar: AppBar(
            title: _nameVal(commissieNameAsync: commissieNameAsync),
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
                        "name": officialName,
                      },
                      queryParameters: {
                        "year": y.toString(),
                      },
                    ),
                    selectedYear: year,
                  ),
                ].toRow(),
              ]
                  .toRow(mainAxisAlignment: MainAxisAlignment.spaceBetween)
                  .padding(
                    right: yearSelectorPadding,
                  ),
              commissieLeedenAsync.when(
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
              final userId = currentUser.identifier;
              if (groupId == null) return const SizedBox.shrink();
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
                        heroTag: "Commissie -> Edit",
                        foregroundColor: colorScheme.onTertiaryContainer,
                        backgroundColor: colorScheme.tertiaryContainer,
                        onPressed: () {
                          context.goNamed(
                            "Commissie -> Edit",
                            pathParameters: {
                              "name": officialName,
                            },
                            queryParameters: {
                              "year": year.toString(),
                              "groupId": groupId.toString(),
                            },
                          );
                        },
                        icon: const Icon(Icons.edit_outlined),
                        label: const Text('Edit'),
                      ),
                      const SizedBox(height: 12),
                      if (officialName.toLowerCase() == "almanakcommissie")
                        FloatingActionButton.extended(
                          heroTag: 'profielfoto\'s downloaden',
                          foregroundColor: colorScheme.onPrimaryContainer,
                          backgroundColor: colorScheme.primaryContainer,
                          onPressed: () {
                            context.goNamed(
                              "download profile pictures",
                              pathParameters: {
                                "name": officialName,
                              },
                            );
                          },
                          icon: const Icon(Icons.download),
                          label: Text("download profile pictures"),
                        ),
                      //
                      // USED ONLY IN THE BEGINNING OF THE
                      // YEAR FOR UPLOADING ASPI PROFILE PICTURES
                      //
                      // if (name.toLowerCase() == "afroeicommissie")
                      //   FloatingActionButton.extended(
                      //     heroTag: 'profielfoto\'s uploaden',
                      //     foregroundColor: colorScheme.onPrimaryContainer,
                      //     backgroundColor: colorScheme.primaryContainer,
                      //     onPressed: () {
                      //       context.goNamed(
                      //         "upload aspi profile pictures",
                      //         pathParameters: {
                      //           "name": name,
                      //         },
                      //       );
                      //     },
                      //     icon: const Icon(Icons.upload),
                      //     label: Text("upload aspi profile pictures"),
                      //   ),
                      //
                      //            END COMMENT
                      //
                    ],
                  );
                },
                loading: () => null,
                error: (e, s) => const SizedBox.shrink(),
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
      loading: () => const Center(
        child: CircularProgressIndicator.adaptive(),
      ),
      error: (e, s) => ErrorCardWidget(errorMessage: e.toString()),
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
      infix: user.infix,
      subtitle: relation.role,
      lidnummer: user.iid.toString(),
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
