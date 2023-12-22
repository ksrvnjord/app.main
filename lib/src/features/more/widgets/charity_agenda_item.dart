import 'package:flutter/material.dart';

class CharityAgendaItem extends StatelessWidget {
  const CharityAgendaItem({
    super.key,
    required this.date,
    required this.eventName,
  });

  final String date;
  final String eventName;

  @override
  Widget build(BuildContext context) {
    return ListTile(title: Text(date), subtitle: Text(eventName));
  }
}
