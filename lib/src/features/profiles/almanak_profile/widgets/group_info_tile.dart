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
    const double chipSpacing = 8;
    const double runSpacing = 8;

    return ListTile(
      title: Text(header).fontSize(commissieNameFontSize),
      subtitle: <Widget>[
        Chip(
          avatar: const Icon(
            Icons.date_range,
          ),
          label: Text("$startYear-$endYear"),
          labelPadding: const EdgeInsets.symmetric(horizontal: 2),
        ),
        if (tags != null)
          ...(tags as List<Tag>)
              .map((tag) => Chip(
                    avatar: Icon(
                      tag.icon,
                    ),
                    label: Text(tag.label),
                    labelPadding: const EdgeInsets.symmetric(horizontal: 2),
                    backgroundColor: tag.backgroundColor,
                  ))
              .toList(),
      ].toWrap(spacing: chipSpacing, runSpacing: runSpacing),
      tileColor: Colors.white,
    );
  }
}
