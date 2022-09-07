import 'package:flutter/material.dart';
import 'package:styled_widget/styled_widget.dart';

class AnnouncementWidget extends StatelessWidget {
  const AnnouncementWidget(
      {Key? key,
      required this.title,
      required this.text,
      required this.subtitle})
      : super(key: key);

  final String title;
  final String subtitle;
  final String text;

  @override
  Widget build(BuildContext context) {
    return <Widget>[
      Text('Title'),
      Text('Subtitle'),
      Text('Text'),
    ].toColumn().expanded().card();
  }
}
