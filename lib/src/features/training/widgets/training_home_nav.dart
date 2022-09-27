import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:routemaster/routemaster.dart';
import 'package:styled_widget/styled_widget.dart';

class TrainingHomeNav extends StatelessWidget {
  const TrainingHomeNav({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var navigator = Routemaster.of(context);

    return <Widget>[
      ElevatedButton(
              onPressed: () => navigator.push('all'),
              style:
                  ElevatedButton.styleFrom(backgroundColor: Colors.lightBlue),
              child: <Widget>[
                const Icon(LucideIcons.sheet).padding(bottom: 1),
                const Text('Overzicht', style: TextStyle(fontSize: 18))
                    .padding(vertical: 16)
              ].toRow(mainAxisAlignment: MainAxisAlignment.spaceBetween))
          .padding(all: 4)
          .expanded(),
      ElevatedButton(
              onPressed: null,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blueGrey),
              child: <Widget>[
                const Icon(LucideIcons.calendarSearch).padding(bottom: 1),
                const Text('Planner', style: TextStyle(fontSize: 18))
                    .padding(vertical: 16)
              ].toRow(mainAxisAlignment: MainAxisAlignment.spaceBetween))
          .padding(all: 4)
          .expanded(),
    ].toRow().padding(all: 8);
  }
}
