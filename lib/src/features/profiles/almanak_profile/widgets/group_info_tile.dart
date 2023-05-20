import 'package:flutter/material.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/almanak_profile/model/tag.dart';
import 'package:styled_widget/styled_widget.dart';

class GroupInfoTile extends StatelessWidget {
  const GroupInfoTile({
    super.key,
    required this.header,
    required this.startYear,
    required this.endYear,
    this.tags,
  });

  final String header;
  final int startYear;
  final int endYear;
  final List<Tag>? tags;

  @override
  Widget build(BuildContext context) {
    const double commissieNameFontSize = 20;
    const double iconSize = 14;
    const double chipSpacing = 8;
    const double runSpacing = 8;

    return ListTile(
      title: Text(header).fontSize(commissieNameFontSize),
      subtitle: <Widget>[
        Chip(
          avatar: const Icon(Icons.date_range, size: 14, color: Colors.white),
          label: Text("$startYear-$endYear"),
          labelStyle: const TextStyle(color: Colors.white),
          labelPadding: const EdgeInsets.only(left: 2, right: 8),
          backgroundColor: Colors.blueGrey[200],
        ),
        if (tags != null)
          ...tags!
              .map((tag) => Chip(
                    avatar: Icon(tag.icon, size: iconSize, color: Colors.white),
                    label: Text(tag.label),
                    labelStyle: const TextStyle(color: Colors.white),
                    labelPadding: const EdgeInsets.only(right: 8),
                    backgroundColor: tag.backgroundColor,
                  ))
              .toList(),
      ].toWrap(spacing: chipSpacing, runSpacing: runSpacing),
      tileColor: Colors.white,
    );
  }
}
