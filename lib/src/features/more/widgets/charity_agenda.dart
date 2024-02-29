import 'package:flutter/material.dart';
import 'package:ksrvnjord_main_app/src/features/more/widgets/charity_agenda_item.dart';

class CharityAgenda extends StatelessWidget {
  const CharityAgenda({super.key});

  @override
  Widget build(BuildContext context) {
    const width2 = 400.0;
    const height2 = 200.0;

    return SizedBox(
      width: width2,
      height: height2,
      child: ListView(
        children: const [
          CharityAgendaItem(date: '12 maart', eventName: 'Hollandia Borrel'),
          CharityAgendaItem(
            date: '19,20,21 maart',
            eventName: 'Hollandia Lustrum Wedstrijden',
          ),
          CharityAgendaItem(date: '28 april', eventName: 'Haringparty'),
          CharityAgendaItem(date: '9 mei', eventName: 'Lustrum Wielerronde'),
        ],
      ),
    );
  }
}
