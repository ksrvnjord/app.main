import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ksrvnjord_main_app/src/features/admin/groups/groups_provider.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/api/substructure_picture_provider.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/widgets/verticalen_choice_list_tile.dart';

class VerticalenChoicePage extends ConsumerStatefulWidget {
  const VerticalenChoicePage({
    super.key,
    required this.title,
    required this.gender,
  });

  final String title;
  final String gender;

  @override
  ConsumerState<VerticalenChoicePage> createState() =>
      _VerticalenChoicePageState();
}

class _VerticalenChoicePageState extends ConsumerState<VerticalenChoicePage> {
  late String selectedGender;

  @override
  void initState() {
    super.initState();
    selectedGender = widget.gender;
  }

  @override
  Widget build(BuildContext context) {
    final verticalenVal = ref.watch(verticalenProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 8, bottom: 8),
            child: Row(
              children: [
                for (final type in ['Dames', 'Heren'])
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: ChoiceChip(
                      label: Text(type),
                      selected: type == selectedGender,
                      onSelected: (selected) {
                        if (!selected) {
                          return;
                        }

                        setState(() {
                          selectedGender = type;
                        });

                        // ignore: avoid-ignoring-return-values
                        context.goNamed(
                          'Verticalen',
                          queryParameters: {'gender': type},
                        );
                      },
                    ),
                  ),
              ],
            ),
          ),
          Expanded(
            child: verticalenVal.when(
              data: (verticalen) {
                final filteredVerticalen = verticalen
                    .where(
                      (vertical) => vertical['name'].startsWith(selectedGender),
                    )
                    .toList()
                  ..sort(
                      (a, b) => a['name'].length.compareTo(b['name'].length));

                if (filteredVerticalen.isEmpty) {
                  return Center(
                    child: Text(
                      'Geen verticalen gevonden voor $selectedGender.',
                    ),
                  );
                }

                return ListView.separated(
                  itemCount: filteredVerticalen.length,
                  separatorBuilder: (_, __) => const Divider(height: 0),
                  itemBuilder: (context, index) {
                    final vertical = filteredVerticalen[index];
                    final verticalId = vertical['id'];
                    final verticalName = vertical['name'];

                    return VerticalenChoiceListTile(
                      name: verticalName,
                      onTap: () => context.goNamed(
                        'Verticaal',
                        pathParameters: {'id': verticalId.toString()},
                      ),
                      imageProvider: ref.watch(
                          verticaalThumbnailProvider(verticalName.toString())),
                    );
                  },
                );
              },
              error: (error, stackTrace) => Center(
                child: Text(error.toString()),
              ),
              loading: () => const Center(
                child: CircularProgressIndicator.adaptive(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
