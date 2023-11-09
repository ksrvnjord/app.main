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

class ManageGroupsPage extends ConsumerWidget {
  const ManageGroupsPage({
    Key? key,
    required this.year,
    this.type,
  }) : super(key: key);

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
    String? name,
  ) {
    final nameController = TextEditingController(text: name)
      ..selection = TextSelection.collapsed(
        offset: name?.length ?? 0,
      ); // If keyboard collapses, it triggers rebuild, which resets the selection. So we need to set it again.

    return Consumer(
      builder: (context, ref, _) {
        final notifierProvider = ref.watch(djangoGroupNotifierProvider);
        final year = notifierProvider.year;
        final type = notifierProvider.type;
        const double dropdownMenuHeight = 240;

        const double cardPadding = 16;

        return [
          Text(
            'Maak nieuwe groep',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          TextField(
            controller: nameController,
            decoration: const InputDecoration(
              labelText: 'Naam',
              border: OutlineInputBorder(),
            ),
            autocorrect: false,
            onChanged: (value) =>
                ref.read(djangoGroupNotifierProvider.notifier).setName(value),
          ),
          DropdownButtonFormField<int>(
            items: yearsFrom1874
                .map((year) => DropdownMenuItem<int>(
                      value: year.item1,
                      child: Text("${year.item1}-${year.item2}"),
                    ))
                .toList(),
            value: year,
            onChanged: (value) => ref
                .read(djangoGroupNotifierProvider.notifier)
                .setYear(value ?? getNjordYear()),
            decoration: const InputDecoration(
              labelText: 'Jaar',
              border: OutlineInputBorder(),
            ),
            menuMaxHeight: dropdownMenuHeight,
          ),
          DropdownButtonFormField<String>(
            items: groupTypes.map((type) {
              return DropdownMenuItem<String>(
                value: type,
                child: Text(type),
              );
            }).toList(),
            value: type,
            onChanged: (value) => ref
                .read(djangoGroupNotifierProvider.notifier)
                .setType(value ?? "Competitieploeg"),
            decoration: const InputDecoration(
              labelText: 'Type',
              border: OutlineInputBorder(),
            ),
          ),
          FilledButton(
            // ignore: prefer-extracting-callbacks
            onPressed: () {
              createNewGroup(
                group: DjangoGroup(
                  name: nameController.text.trim(),
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
              bottom: MediaQuery.of(context).viewInsets.bottom + 16,
            );
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final groupsVal = ref.watch(groupsProvider(Tuple2(type, year)));

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
                    'type': type == this.type ? null : type,
                  },
                ),
                selected: type == this.type,
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
                'type': type,
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
          ref
              .read(djangoGroupNotifierProvider.notifier)
              .setType(type ?? "Competitieploeg");
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
