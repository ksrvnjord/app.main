import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mijn afschrijvingen'),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.lightBlue,
        shadowColor: Colors.transparent,
        systemOverlayStyle:
            const SystemUiOverlayStyle(statusBarColor: Colors.lightBlue),
      ),
      body: const TrainingList(),
      floatingActionButton: FirebaseWidget(
        onAuthenticated: Wrap(
          spacing: spacingFloatingButtons,
          runSpacing: runSpacingFloatingButtons,
          alignment: WrapAlignment.end,
          children: [
            FloatingActionButton.extended(
              onPressed: () => navigator.push('damages'),
              backgroundColor: Colors.blue,
              icon: const Icon(Icons.report),
              label: const Text('Schademeldingen'),
            ),
            FloatingActionButton.extended(
              onPressed: () => navigator.push('all'),
              backgroundColor: Colors.lightBlue,
              icon: const Icon(Icons.add),
              label: const Text('Afschrijven'),
            ),
          ],
        ),
      ),
    );
  }
}
