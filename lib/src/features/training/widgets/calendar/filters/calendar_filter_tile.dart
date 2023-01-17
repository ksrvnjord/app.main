import 'package:flutter/material.dart';

class CalendarFilterTile extends StatelessWidget {
  final String label;
  final String icon;
  final bool selected;
  final void Function()? onPressed;

  const CalendarFilterTile(
      {Key? key,
      required this.label,
      required this.selected,
      required this.onPressed,
      this.icon = ''})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        backgroundColor: selected ? Colors.lightBlue : Colors.white,
        foregroundColor: selected ? Colors.white : Colors.lightBlue,
        side: BorderSide(
            width: 1.0, color: selected ? Colors.blue : Colors.lightBlue),
      ),
      child: Text(label),
    );
  }
}
