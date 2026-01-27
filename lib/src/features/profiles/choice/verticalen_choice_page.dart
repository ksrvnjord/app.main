import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/widgets/verticalen_choice_list_tile.dart';

class VerticalenChoicePage extends ConsumerStatefulWidget {
  const VerticalenChoicePage({
    super.key,
    required this.title,
    required this.gender,
    required this.choices,
  });

  final String title;
  final String gender;
  final List<String> choices;

  @override
  ConsumerState<VerticalenChoicePage> createState() =>
      _VerticalenChoicePageState();
}

class _VerticalenChoicePageState extends ConsumerState<VerticalenChoicePage> {
  late String selectedGender;

  @override
  void initState() {
    super.initState();
    selectedGender = (widget.gender == 'Heren' || widget.gender == 'Dames')
        ? widget.gender
        : (widget.gender == 'Mannen'
            ? 'Heren'
            : (widget.gender == 'Vrouwen' ? 'Dames' : 'Heren'));
  }

  @override
  Widget build(BuildContext context) {
    final effectiveGender = selectedGender;

    final genderedChoices = widget.choices
        .where((choice) => choice.startsWith(effectiveGender))
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Kies een verticaal'),
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
                      onSelected: (selected) {
                        if (selected) {
                          setState(() {
                            selectedGender = type;
                          });
                          context.goNamed(
                            'Verticalen',
                            queryParameters: {'gender': type},
                          );
                        }
                      },
                      selected: type == selectedGender,
                    ),
                  ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: genderedChoices.length,
              itemBuilder: (context, index) => Column(
                children: [
                  VerticalenChoiceListTile(
                    name: genderedChoices[index],
                    onTap: () => context.goNamed(
                      "Verticaal",
                      pathParameters: {"name": genderedChoices[index]},
                    ),
                  ),
                  const Divider(height: 0, thickness: 0.5),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
