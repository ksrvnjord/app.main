import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ksrvnjord_main_app/src/features/announcements/api/announcements.graphql.dart';
import 'package:ksrvnjord_main_app/src/features/announcements/widgets/announcement_widget.dart';
import 'package:routemaster/routemaster.dart';
import 'package:styled_widget/styled_widget.dart';

class AnnouncementListWidget extends StatelessWidget {
  const AnnouncementListWidget({Key? key, required this.announcements})
      : super(key: key);

  final List<Query$Announcements$announcements$data> announcements;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: announcements
          .map<Widget>(
            (Query$Announcements$announcements$data announcement) {
              var createdDate =
                  DateFormat.yMMMd().format(announcement.created_at);

              return GestureDetector(
                child: AnnouncementWidget(
                  title: announcement.title,
                  subtitle: "${announcement.author} - $createdDate",
                  text: '',
                  padding: const EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 15,
                  ),
                ),
                onTap: () {
                  var routemaster = Routemaster.of(context);
                  routemaster.push(
                    '${routemaster.currentRoute}/announcements/${announcement.id}',
                  );
                },
              );
            },
          )
          .toList()
          .toColumn(crossAxisAlignment: CrossAxisAlignment.stretch),
    );
  }
}
