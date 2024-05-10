import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ksrvnjord_main_app/src/features/dashboard/widgets/lustrum_background_widget.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/choice/widgets/almanak_structure_choice_widget.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/firebase_widget.dart';
import 'package:styled_widget/styled_widget.dart';

class AlmanakPage extends ConsumerWidget {
  const AlmanakPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const double choiceWidgetPadding = 8;
    const pageOffset = 0.0;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Almanak"),
      ),
      body: CustomPaint(
        painter: LustrumBackgroundWidget(pageOffset: pageOffset),
        child: ListView(
          padding: const EdgeInsets.all(8),
          children: [
            const AlmanakStructureChoiceWidget(
              pushRoute: "Leeden",
              title: "Leeden",
              imagePath: 'assets/images/leeden.png',
            ).padding(bottom: choiceWidgetPadding),
            FirebaseWidget(
              onAuthenticated: [
                const AlmanakStructureChoiceWidget(
                  pushRoute: "Bestuur",
                  title: "Bestuur",
                  imagePath: 'assets/images/bestuur.jpg',
                ),
                [
                  const AlmanakStructureChoiceWidget(
                    pushRoute: "Commissies",
                    title: "Commissies",
                    imagePath: 'assets/images/commissies.jpeg',
                  ).expanded(),
                  const AlmanakStructureChoiceWidget(
                    pushRoute: "Ploegen",
                    title: "Ploegen",
                    imagePath: 'assets/images/ploegen.jpg',
                  ).expanded(),
                ].toRow(
                  separator: const SizedBox(
                    width: choiceWidgetPadding,
                  ),
                ),
                [
                  const AlmanakStructureChoiceWidget(
                    pushRoute: "Huizen",
                    title: "Huizen",
                    imagePath: 'assets/images/huizen.jpeg',
                  ).expanded(),
                  const AlmanakStructureChoiceWidget(
                    pushRoute: "Substructuren",
                    title: "Substructuren",
                    imagePath: 'assets/images/substructures.jpeg',
                  ).expanded(),
                ].toRow(
                  separator: const SizedBox(
                    width: choiceWidgetPadding,
                  ),
                ),
              ].toColumn(
                separator: const SizedBox(
                  height: choiceWidgetPadding,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
