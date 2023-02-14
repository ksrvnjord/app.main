import 'package:flutter/material.dart';
import 'package:styled_widget/styled_widget.dart';

class AnnouncementWidget extends StatelessWidget {
  const AnnouncementWidget({
    Key? key,
    required this.title,
    required this.text,
    required this.subtitle,
    this.padding = EdgeInsets.zero,
  }) : super(key: key);

  final String title;
  final String subtitle;
  final String text;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    var announcementText = <Widget>[];

    const double leadingIconPadding = 16;
    const double cardPadding = 16;
    const double titleSize = 16;
    const double subtitleSize = 12;
    const double titleSubtitlePadding = 6;

    (title != '')
        ? announcementText.add(Text(
            title,
            style: const TextStyle(
              fontSize: titleSize,
              fontWeight: FontWeight.bold,
            ),
            overflow: TextOverflow.ellipsis,
          ))
        : null;

    (subtitle != '')
        ? announcementText.add(Text(
            subtitle,
            style: const TextStyle(
              fontSize: subtitleSize,
              fontWeight: FontWeight.w100,
            ),
          ).padding(top: titleSubtitlePadding))
        : null;

    (text != '')
        ? announcementText.add(Text(
            text,
            style: const TextStyle(
              fontSize: subtitleSize,
              fontWeight: FontWeight.w200,
            ),
          ).padding(top: titleSubtitlePadding))
        : null;

    return Padding(
      padding: padding,
      child: <Widget>[
        const Icon(Icons.campaign).padding(horizontal: leadingIconPadding),
        announcementText
            .toColumn(crossAxisAlignment: CrossAxisAlignment.start)
            .padding(vertical: cardPadding)
            .expanded(),
      ].toRow().card(
            elevation: 1,
          ),
    );
  }
}
