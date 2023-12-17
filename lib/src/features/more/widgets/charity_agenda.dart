import 'package:flutter/material.dart';
import 'package:ksrvnjord_main_app/src/features/more/widgets/charity_agenda_item.dart';

class CharityAgenda extends StatelessWidget {
  const CharityAgenda({Key? key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 400,
      height: 200,
      child: ListView(
        children: const [
          CharityAgendaItem(
            date: '22 december',
            eventName: 'Kerstmarkt',
          ),
          CharityAgendaItem(
            date: '21 januari',
            eventName: 'Lustrumsyposium',
          ),
          CharityAgendaItem(
            date: '22 januari',
            eventName: 'Duinloop',
          ),
        ],
      ),
    );
  }
}
