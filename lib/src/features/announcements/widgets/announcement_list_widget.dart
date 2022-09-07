import 'package:flutter/material.dart';
import 'package:ksrvnjord_main_app/src/features/announcements/api/announcements.graphql.dart';
import 'package:ksrvnjord_main_app/src/features/announcements/widgets/announcement_widget.dart';
import 'package:styled_widget/styled_widget.dart';

class AnnouncementListWidget extends StatelessWidget {
  const AnnouncementListWidget({Key? key, required this.announcements})
      : super(key: key);

  final List<Query$Announcements$announcements$data> announcements;

  @override
  Widget build(BuildContext context) {
    return announcements
        .map<Widget>((Query$Announcements$announcements$data announcement) {
          return AnnouncementWidget(
            title: announcement.title,
            subtitle: announcement.author + announcement.created_at.toString(),
            text: '',
          );
        })
        .toList()
        .toColumn()
        .expanded()
        .card();
  }
}
