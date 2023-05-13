import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
        backgroundColor: Colors.lightBlue,
        shadowColor: Colors.transparent,
        systemOverlayStyle:
            const SystemUiOverlayStyle(statusBarColor: Colors.lightBlue),
      ),
      body: ListView(
        padding: const EdgeInsets.all(8),
        children: [
          const AlmanakStructureChoiceWidget(
            title: "Leeden",
            pushRoute: "leeden",
            imagePath: 'assets/images/leeden.png',
          ),
          FirebaseWidget(
            [
              const AlmanakStructureChoiceWidget(
                title: "Bestuur",
                pushRoute: "bestuur",
                imagePath: 'assets/images/bestuur.jpeg',
              ),
              const AlmanakStructureChoiceWidget(
                title: "Commissies",
                pushRoute: "commissies",
                imagePath: 'assets/images/commissies.jpeg',
              ),
              const AlmanakStructureChoiceWidget(
                pushRoute: "huizen",
                title: "Huizen",
                imagePath: 'assets/images/huizen.jpeg',
              ),
              // TODO: Add ploegen
              const AlmanakStructureChoiceWidget(
                title: "Substructuren",
                pushRoute: "substructuren",
                imagePath: 'assets/images/substructures.jpeg',
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
