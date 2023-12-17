import 'package:flutter/material.dart';

class CharityAgendaItem extends StatelessWidget {
  final String date;
  final String eventName;

  const CharityAgendaItem(
      {super.key, required this.date, required this.eventName});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(date),
      subtitle: Text(eventName),
    );
  }
}
