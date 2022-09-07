import 'package:flutter/material.dart';
import 'package:styled_widget/styled_widget.dart';

class AnnouncementWidget extends StatelessWidget {
  const AnnouncementWidget(
      {Key? key,
      required this.title,
      required this.text,
      required this.subtitle,
      this.padding = EdgeInsets.zero})
      : super(key: key);

  final String title;
  final String subtitle;
  final String text;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: padding,
        child: <Widget>[
          Text('Title'),
          Text('Subtitle'),
          Text('Text'),
        ].toColumn().card());
  }
}
