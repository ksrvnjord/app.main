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
    var announcementText = <Widget>[];

    (title != '')
        ? announcementText.add(Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            overflow: TextOverflow.ellipsis,
          ))
        : null;

    (subtitle != '')
        ? announcementText.add(Text(subtitle,
                style:
                    const TextStyle(fontSize: 12, fontWeight: FontWeight.w100))
            .padding(top: 5))
        : null;

    (text != '')
        ? announcementText.add(Text(text,
                style:
                    const TextStyle(fontSize: 14, fontWeight: FontWeight.w200))
            .padding(top: 5))
        : null;

    return Padding(
        padding: padding,
        child: <Widget>[
          const Icon(Icons.campaign).padding(left: 15),
          announcementText
              .toColumn(crossAxisAlignment: CrossAxisAlignment.start)
              .padding(all: 15)
              .expanded()
        ].toRow().card(
              elevation: 1,
            ));
  }
}
