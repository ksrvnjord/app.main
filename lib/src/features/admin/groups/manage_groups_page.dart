import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ksrvnjord_main_app/src/features/admin/groups/groups_provider.dart';
import 'package:ksrvnjord_main_app/src/features/admin/groups/models/django_group.dart';
import 'package:ksrvnjord_main_app/src/features/admin/groups/models/group_types.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/api/njord_year.dart';
import 'package:ksrvnjord_main_app/src/features/shared/data/years_from_1874.dart';
import 'package:ksrvnjord_main_app/src/features/shared/model/dio_provider.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/error_card_widget.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:tuple/tuple.dart';

const List<String> commissieList = [
  'Afroeicommissie',
  'Almanakcommissie',
  'Appcommissie',
  'Archiefcommissie',
  'Blasphemycommissie',
  'Buffetcommissie',
  'Competitiecommissie',
  'Diskjockeycommissie',
  'Duurzaamheidscommissie',
  'Eerstejaarscommissie',
  'Extern Roeiencommissie',
  'Externe Commissie',
  'Fotocommissie',
  'Fuifroeicommissie',
  'Galacommissie',
  'Goede Doelencommissie',
  'Grautgilde der Baufakkerei',
  'Haringpartij Comité',
  'Hollandiacommissie',
  'Introductiecommissie',
  'Kalendercommissie',
  'Kookcluster',
  'Kookcommissie',
  'Materieelgroep',
  'Meerderejaarscommissie',
  'Merchandisecommissie',
  'Njord Najaarscommissie',
  'NSRF-commissie',
  'Pascommissie',
  'Petit Comité',
  'Promotiecommissie',
  'Ringvaartcommissie',
  'Rowing Blindcommissie',
  'Sjaarzencommissie',
  'Skireiscommissie',
  'Talentwervingscommissie',
  'Tapcommissie',
  'TOP-commissie',
  'Twaarzencommissie',
  'Voorjaarsafroeicommissie',
  'Vrouwencomité',
  'Zwanehalscommissie',
];

String _toSlug(String value) {
  return value.toLowerCase().replaceAll(' ', '');
}

final List<String> commissieListSlugs = commissieList.map(_toSlug).toList();

class ManageGroupsPage extends ConsumerWidget {
  const ManageGroupsPage({
    super.key,
    required this.year,
    this.type,
  });

  final int year;
  final String? type;

  Future<void> createNewGroup({
    required DjangoGroup group,
    required WidgetRef ref,
    required BuildContext ctx,
  }) async {
    final dio = ref.read(dioProvider);
    try {
      // ignore: avoid-ignoring-return-values
      await dio.post(
        "/api/users/groups/",
        data: group.toJson(),
      );
    } catch (e) {
      if (ctx.mounted) {
        // ignore: avoid-ignoring-return-values
        ScaffoldMessenger.of(ctx).showSnackBar(
          const SnackBar(
            content: Text(
              "Het is niet gelukt om de groep aan te maken.",
            ),
          ),
        );

        return;
      }
    }

    if (!ctx.mounted) return;
    // ignore: avoid-ignoring-return-values
    ScaffoldMessenger.of(ctx).showSnackBar(
      const SnackBar(content: Text("Groep is aangemaakt.")),
    );
    // ignore: avoid-ignoring-return-values
    ref.invalidate(groupsProvider);
  }

  Widget _buildCreateGroupBottomSheet(
    String name,
  ) {
    final nameController = TextEditingController(text: name)
      ..selection = TextSelection.collapsed(
        offset: name.length,
      ); // If keyboard collapses, it triggers rebuild, which resets the selection. So we need to set it again.

    return Consumer(
      builder: (context, ref, _) {
        final notifierProvider = ref.watch(djangoGroupNotifierProvider);
        final year = notifierProvider.year;
        final type = notifierProvider.type;
        final officialName = notifierProvider.officialName;
        const double dropdownMenuHeight = 240;

        const double cardPadding = 16;

        const double bottomPaddingModal = 16;

        Widget nameWidget() {
          switch (type) {
            case "Commissie":
              final groupsVal = ref.watch(groupsProvider(Tuple2(type, year)));
              final currentCommissieList = groupsVal.whenData((data) {
                    return data.map((group) => group.name).toList();
                  }).value ??
                  [];

              final availableCommissieList = commissieList
                  .where(
                      (commissie) => !currentCommissieList.contains(commissie))
                  .toList();

              final selectedCommissieIndex =
                  availableCommissieList.indexOf(officialName);

              return [
                DropdownButtonFormField<int>(
                  items: availableCommissieList
                      .map((name) => DropdownMenuItem<int>(
                            value: availableCommissieList.indexOf(name),
                            child: Text(name),
                          ))
                      .toList(),
                  value: selectedCommissieIndex >= 0
                      ? selectedCommissieIndex
                      : null,
                  onChanged: (value) {
                    if (value == null) return;
                    final selectedCommissie = availableCommissieList[value];
                    nameController.text = selectedCommissie;
                    nameController.selection = TextSelection.collapsed(
                      offset: selectedCommissie.length,
                    );
                    ref
                        .read(djangoGroupNotifierProvider.notifier)
                        .setOfficialName(selectedCommissie);
                    ref
                        .read(djangoGroupNotifierProvider.notifier)
                        .setName(selectedCommissie);
                  },
                  decoration: const InputDecoration(
                    labelText: "Kies een commissie",
                    border: OutlineInputBorder(),
                  ),
                  menuMaxHeight: dropdownMenuHeight,
                ),
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                      labelText: 'Zichtbare naam',
                      border: OutlineInputBorder()),
                  autocorrect: false,
                  onChanged: (value) => ref
                      .read(djangoGroupNotifierProvider.notifier)
                      .setName(value),
                )
              ].toColumn(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                separator: const SizedBox(height: 16),
              );

            // case "Competitieploeg":
            // case "Wedstrijdsectie":
            // case "Bestuur":
          }
          return TextField(
            controller: nameController,
            decoration: const InputDecoration(
                labelText: 'Naam', border: OutlineInputBorder()),
            autocorrect: false,
            onChanged: (value) =>
                ref.read(djangoGroupNotifierProvider.notifier).setName(value),
          );
        }

        return [
          Text(
            'Maak nieuwe groep',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          DropdownButtonFormField<String>(
            items: groupTypes.map((type) {
              return DropdownMenuItem<String>(
                value: type,
                child: Text(type),
              );
            }).toList(),
            value: type,
            onChanged: (value) {
              ref
                  .read(djangoGroupNotifierProvider.notifier)
                  .setType(value ?? "Competitieploeg");

              ref.read(djangoGroupNotifierProvider.notifier).setName("");

              nameController.text = "";
            },
            decoration: const InputDecoration(
              labelText: 'Type',
              border: OutlineInputBorder(),
            ),
          ),
          nameWidget(),
          DropdownButtonFormField<int>(
            items: yearsFrom1874
                .map((year) => DropdownMenuItem<int>(
                      value: year.item1,
                      child: Text("${year.item1}-${year.item2}"),
                    ))
                .toList(),
            value: year,
            onChanged: (value) {
              ref
                  .read(djangoGroupNotifierProvider.notifier)
                  .setYear(value ?? getNjordYear());

              ref.read(djangoGroupNotifierProvider.notifier).setName("");

              nameController.text = "";
            },
            decoration: const InputDecoration(
              labelText: 'Jaar',
              border: OutlineInputBorder(),
            ),
            menuMaxHeight: dropdownMenuHeight,
          ),
          FilledButton(
            // ignore: prefer-extracting-callbacks
            onPressed: () {
              createNewGroup(
                group: DjangoGroup(
                  name: nameController.text.trim(),
                  officialName: _toSlug(officialName),
                  type: type,
                  year: year,
                ),
                ref: ref,
                ctx: context,
              );
              Navigator.of(context).pop();
            },
            child: const Text('Maak groep'),
          ),
        ]
            .toColumn(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              separator: const SizedBox(height: 16),
            )
            .padding(
              all: cardPadding,
              bottom:
                  MediaQuery.of(context).viewInsets.bottom + bottomPaddingModal,
            );
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedType = (type == null || type!.isEmpty) ? "Commissie" : type!;
    final groupsVal = ref.watch(groupsProvider(Tuple2(selectedType, year)));

    const double dropdownMaxHeight = 240;

    const double wrapSpacing = 8;
    const double wrapPadding = 8;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Beheer groepen'),
      ),
      body: ListView(
        children: [
          [
            for (final type in groupTypes)
              ChoiceChip(
                label: Text(type),
                onSelected: (selected) => context.goNamed(
                  'Manage Groups',
                  queryParameters: {
                    'year': year.toString(),
                    'type': type,
                  },
                ),
                selected: type == selectedType,
              ),
            DropdownButton<int>(
              items: yearsFrom1874
                  .map((njordYear) => DropdownMenuItem(
                        value: njordYear.item1,
                        child: Text("${njordYear.item1}-${njordYear.item2}"),
                      ))
                  .toList(),
              value: year,
              onChanged: (value) =>
                  context.goNamed('Manage Groups', queryParameters: {
                'year': value.toString(),
                'type': selectedType,
              }),
              menuMaxHeight: dropdownMaxHeight,
            ),
          ]
              .toWrap(
                spacing: wrapSpacing,
              )
              .paddingDirectional(horizontal: wrapPadding),
          groupsVal.when(
            data: (data) {
              return data.isEmpty
                  ? const Center(
                      child: Text('Geen groepen gevonden.'),
                    )
                  : [
                      for (var group in data)
                        ListTile(
                          title: Text(group.name),
                          subtitle: Text(group.type),
                          trailing: const Icon(Icons.arrow_forward_ios),
                          onTap: () => context.goNamed(
                            'Edit Group',
                            pathParameters: {
                              'id': group.id.toString(),
                            },
                            queryParameters: {
                              "type": group.type,
                              "year": group.year.toString(),
                            },
                          ),
                        ),
                      SizedBox(
                        height: 96.0,
                      ),
                    ].toColumn();
            },
            error: (err, stk) => ErrorCardWidget(errorMessage: err.toString()),
            loading: () =>
                const Center(child: CircularProgressIndicator.adaptive()),
          ),
        ],
      ),
      floatingActionButton: // Extended floating action button to Create a group.
          FloatingActionButton.extended(
        // ignore: prefer-extracting-callbacks
        onPressed: () {
          ref.read(djangoGroupNotifierProvider.notifier).setType(selectedType);
          ref.read(djangoGroupNotifierProvider.notifier).setYear(year);
          // ignore: avoid-ignoring-return-values
          showModalBottomSheet(
            context: context,
            builder: (context) {
              final name = ref.read(djangoGroupNotifierProvider).name;

              return _buildCreateGroupBottomSheet(name);
            },
            isScrollControlled: true,
          );
        },
        icon: const Icon(Icons.add),
        label: const Text('Nieuwe groep'),
      ),
    );
  }
}
