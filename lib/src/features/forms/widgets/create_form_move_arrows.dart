import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ksrvnjord_main_app/src/features/forms/pages/create_form_page.dart';

class CreateFormMoveArrows extends ConsumerWidget {
  const CreateFormMoveArrows({
    super.key,
    required this.index,
    required this.contentIndex,
  });

  final int index;
  final int contentIndex;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = context.findAncestorStateOfType<CreateFormPageState>()!;
    final isFirst = index == 0;
    final isLast = index == state.formContentObjectIndices.length - 1;
    final double arrowDistanceHeigth = 64;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (!isFirst)
          IconButton(
            icon: const Icon(Icons.arrow_upward),
            tooltip: 'Verplaats omhoog',
            onPressed: () => state.moveQuestionOrFiller(index, true),
          ),
        SizedBox(
          height: arrowDistanceHeigth,
        ),
        if (!isLast)
          IconButton(
            icon: const Icon(Icons.arrow_downward),
            tooltip: 'Verplaats omlaag',
            onPressed: () => state.moveQuestionOrFiller(index, false),
          ),
      ],
    );
  }
}
