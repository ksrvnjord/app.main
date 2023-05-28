import 'package:flutter/material.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/firebase_widget.dart';
import 'package:ksrvnjord_main_app/src/features/training/widgets/training_list.dart';
import 'package:routemaster/routemaster.dart';

class TrainingPage extends StatelessWidget {
  const TrainingPage({Key? key}) : super(key: key);

  static const double spacingFloatingButtons = 10;
  static const double runSpacingFloatingButtons = 12;

  @override
  Widget build(BuildContext context) {
    Routemaster navigator = Routemaster.of(context);

    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mijn afschrijvingen'),
      ),
      body: const TrainingList(),
      floatingActionButton: FirebaseWidget(
        onAuthenticated: Wrap(
          alignment: WrapAlignment.end,
          spacing: spacingFloatingButtons,
          runSpacing: runSpacingFloatingButtons,
          children: [
            FloatingActionButton.extended(
              backgroundColor: colorScheme.secondaryContainer,
              onPressed: () => navigator.push('damages'),
              icon: const Icon(Icons.report),
              label: const Text('Schademeldingen'),
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
