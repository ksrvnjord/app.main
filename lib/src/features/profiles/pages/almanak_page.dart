import 'package:flutter/material.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/choice/widgets/almanak_structure_choice_widget.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/firebase_widget.dart';
import 'package:styled_widget/styled_widget.dart';

class AlmanakPage extends StatelessWidget {
  const AlmanakPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const double choiceWidgetPadding = 8;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Almanak"),
      ),
      body: ListView(
        padding: const EdgeInsets.all(8),
        children: [
          const AlmanakStructureChoiceWidget(
            pushRoute: "leeden",
            title: "Leeden",
            imagePath: 'assets/images/leeden.png',
          ).padding(bottom: choiceWidgetPadding),
          FirebaseWidget(
            onAuthenticated: [
              const AlmanakStructureChoiceWidget(
                pushRoute: "bestuur",
                title: "Bestuur",
                imagePath: 'assets/images/bestuur.jpeg',
              ),
              [
                const AlmanakStructureChoiceWidget(
                  pushRoute: "commissies",
                  title: "Commissies",
                  imagePath: 'assets/images/commissies.jpeg',
                ).expanded(),
                const AlmanakStructureChoiceWidget(
                  pushRoute: "ploegen",
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
                  pushRoute: "huizen",
                  title: "Huizen",
                  imagePath: 'assets/images/huizen.jpeg',
                ).expanded(),
                const AlmanakStructureChoiceWidget(
                  pushRoute: "substructuren",
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
    );
  }
}
