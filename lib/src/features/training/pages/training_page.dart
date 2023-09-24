import 'package:flutter/material.dart';
import 'package:ksrvnjord_main_app/src/features/dashboard/widgets/lustrum_background_widget.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/firebase_widget.dart';
import 'package:ksrvnjord_main_app/src/features/training/widgets/training_list.dart';
import 'package:routemaster/routemaster.dart';
import 'package:styled_widget/styled_widget.dart';

class TrainingPage extends StatelessWidget {
  const TrainingPage({Key? key}) : super(key: key);

  static const double spacingFloatingButtons = 10;
  static const double runSpacingFloatingButtons = 12;

  @override
  Widget build(BuildContext context) {
    Routemaster navigator = Routemaster.of(context);
    const pageOffset = 0.0;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mijn afschrijvingen'),
      ),
      body: CustomPaint(
        // ignore: sort_child_properties_last
        painter: LustrumBackgroundWidget(
          screenSize: MediaQuery.of(context).size,
          pageOffset: pageOffset,
        ),
        child: const TrainingList(),
      ),
      floatingActionButton: FirebaseWidget(
        onAuthenticated: Wrap(
          alignment: WrapAlignment.end,
          spacing: spacingFloatingButtons,
          runSpacing: runSpacingFloatingButtons,
          children: [
            FloatingActionButton.extended(
              backgroundColor: colorScheme.secondaryContainer,
              onPressed: () => navigator.push('damages'),
              icon: Icon(Icons.report, color: colorScheme.onSecondaryContainer),
              label: const Text(
                'Schademeldingen',
              ).textColor(colorScheme.onSecondaryContainer),
            ),
            FloatingActionButton.extended(
              backgroundColor: colorScheme.primaryContainer,
              onPressed: () => navigator.push('all'),
              icon: const Icon(Icons.add),
              label: const Text('Afschrijven'),
            ),
          ],
        ),
      ),
    );
  }
}
