import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ksrvnjord_main_app/src/features/dashboard/widgets/lustrum_background_widget.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/firebase_widget.dart';
import 'package:ksrvnjord_main_app/src/features/training/widgets/training_list.dart';
import 'package:styled_widget/styled_widget.dart';

class TrainingPage extends StatelessWidget {
  const TrainingPage({Key? key}) : super(key: key);

  static const double spacingFloatingButtons = 10;
  static const double runSpacingFloatingButtons = 12;

  @override
  Widget build(BuildContext context) {
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
        child: [
          TrainingList(),
          SizedBox(height: 32),
          DottedBorder(
            color: Colors.blueGrey,
            strokeWidth: 4,
            borderType: BorderType.RRect,
            radius: const Radius.circular(16),
            strokeCap: StrokeCap.square,
            dashPattern: [8, 8],
            child: Text("Uw logo hier",
                style: Theme.of(context).textTheme.displayLarge?.copyWith(
                      color: Colors.blueGrey,
                      fontWeight: FontWeight.bold,
                    )).padding(all: 32, top: 32, bottom: 32),
          ),
        ].toColumn(),
      ),
      floatingActionButton: FirebaseWidget(
        onAuthenticated: Wrap(
          alignment: WrapAlignment.end,
          spacing: spacingFloatingButtons,
          runSpacing: runSpacingFloatingButtons,
          children: [
            FloatingActionButton.extended(
              backgroundColor: colorScheme.secondaryContainer,
              heroTag: null, // Prevents hero animation from playing.
              onPressed: () => context.goNamed('Damages'),
              icon: Icon(Icons.report, color: colorScheme.onSecondaryContainer),
              label: const Text('Schademeldingen')
                  .textColor(colorScheme.onSecondaryContainer),
            ),
            FloatingActionButton.extended(
              backgroundColor: colorScheme.primaryContainer,
              heroTag: null, // Prevents hero animation from playing.
              onPressed: () => context.goNamed('Planning Overview'),
              icon: const Icon(Icons.add),
              label: const Text('Afschrijven'),
            ),
          ],
        ),
      ),
    );
  }
}
