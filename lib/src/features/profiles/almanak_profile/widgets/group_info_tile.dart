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

    return ListTile(
      tileColor: Colors.white,
      title: Text(header).fontSize(commissieNameFontSize),
      subtitle: <Widget>[
        Chip(
          label: Text(
            "$startYear-$endYear",
          ),
          avatar: const Icon(
            Icons.date_range,
            color: Colors.white,
            size: 14,
          ),
          backgroundColor: Colors.blueGrey[200],
          labelPadding: const EdgeInsets.only(left: 2, right: 8),
          labelStyle: const TextStyle(
            color: Colors.white,
          ),
        ),
        if (tags != null)
          ...tags!
              .map((tag) => Chip(
                    label: Text(tag.label),
                    labelStyle: const TextStyle(
                      color: Colors.white,
                    ),
                    // show avatar
                    avatar: Icon(
                      tag.icon,
                      color: Colors.white,
                      size: iconSize,
                    ),
                    labelPadding: const EdgeInsets.only(right: 8),
                    backgroundColor: tag.backgroundColor,
                  ))
              .toList(),
      ].toWrap(
        spacing: chipSpacing,
        // ignore: no-equal-arguments
        runSpacing: chipSpacing,
      ),
    );
  }
}
