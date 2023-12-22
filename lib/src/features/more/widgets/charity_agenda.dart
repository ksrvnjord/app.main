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
          CharityAgendaItem(date: '22 december', eventName: 'Kerstmarkt'),
          CharityAgendaItem(
            date: '21 januari',
            eventName: 'Lustrumsyposium',
          ),
          CharityAgendaItem(date: '22 januari', eventName: 'Duinloop'),
        ],
      ),
    );
  }
}
