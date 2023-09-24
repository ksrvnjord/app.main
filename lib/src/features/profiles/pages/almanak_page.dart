import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:ksrvnjord_main_app/src/features/dashboard/widgets/lustrum_background_widget.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/choice/widgets/almanak_structure_choice_widget.dart';
import 'package:ksrvnjord_main_app/src/features/shared/model/current_user.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/firebase_widget.dart';
import 'package:routemaster/routemaster.dart';
import 'package:styled_widget/styled_widget.dart';

class AlmanakPage extends StatelessWidget {
  const AlmanakPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const double choiceWidgetPadding = 8;
    const pageOffset = 0.0;

    final currentUser = GetIt.I<CurrentUser>();
    final bool isVisibleInAlmanak = currentUser.user?.listed ?? true;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Almanak"),
      ),
      body: CustomPaint(
        painter: LustrumBackgroundWidget(
          screenSize: MediaQuery.of(context).size,
          pageOffset: pageOffset,
        ),
        child: ListView(
          padding: const EdgeInsets.all(8),
          children: [
            if (!isVisibleInAlmanak)
              MaterialBanner(
                content: const Text('Je bent niet zichtbaar in de almanak.'),
                actions: [
                  TextButton(
                    onPressed: () => Routemaster.of(context)
                        .replace('/home/my-profile/settings/visibility'),
                    child: const Text('Wijzig'),
                  ),
                ],
                leading: const CircleAvatar(child: Icon(Icons.visibility_off)),
                dividerColor: Colors.transparent,
              ),
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
      ),
    );
  }
}
