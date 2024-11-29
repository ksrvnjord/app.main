import 'package:flutter/material.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/almanak_profile/model/tag.dart';
import 'package:styled_widget/styled_widget.dart';

class GroupInfoTile extends StatelessWidget {
  const GroupInfoTile({
    required this.endYear,
    required this.header,
    super.key,
    required this.onTap,
    required this.startYear,
    this.tags,
  });

  final String header;
  final int startYear;
  final int endYear;
  final List<Tag>? tags;
  final void Function() onTap;

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
          ...(tags as List<Tag>).map((tag) => Chip(
                avatar: Icon(
                  tag.icon,
                ),
                label: Text(tag.label),
                labelPadding: const EdgeInsets.symmetric(horizontal: 2),
                backgroundColor: tag.backgroundColor,
              )),
      ].toWrap(spacing: chipSpacing, runSpacing: runSpacing),
      trailing: Icon(
        Icons.arrow_forward_ios,
        color: Theme.of(context).colorScheme.primary,
      ),
      onTap: onTap,
    );
  }
}
