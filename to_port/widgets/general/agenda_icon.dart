import 'package:flutter/material.dart';
import 'package:ksrvnjord_main_app/pages/main/agenda/agenda.dart';

class AgendaCard extends StatelessWidget {
  const AgendaCard({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: IconButton(
          icon: const Icon(Icons.calendar_today),
          color: Colors.white,
          padding: EdgeInsets.zero,
          iconSize: 28,
          alignment: Alignment.center,
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => AgendaPage()));
          }),
    );
  }
}
