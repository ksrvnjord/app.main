import 'package:flutter/material.dart';
import 'package:ksrvnjord_main_app/src/features/training/widgets/coach_or_cox_navigation_widget.dart';

class CoachOrCoxNeededPage extends StatelessWidget {
  const CoachOrCoxNeededPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Coach of Stuur')),
      body: ListView(
        children: const [
          CoachOrCoxNavigationWidget(
            label: 'Coach zoeken',
            routeName: 'SearchRole',
            role: 'coach',
          ),
          CoachOrCoxNavigationWidget(
            label: 'Stuur zoeken',
            routeName: 'SearchRole',
            role: 'stuur',
          ),
          CoachOrCoxNavigationWidget(
            label: 'Zichtbaar worden als coach',
            routeName: 'RegisterRole',
            role: 'coach',
          ),
          CoachOrCoxNavigationWidget(
            label: 'Zichtbaar worden als stuur',
            routeName: 'RegisterRole',
            role: 'stuur',
          ),
        ],
      ),
    );
  }
}
