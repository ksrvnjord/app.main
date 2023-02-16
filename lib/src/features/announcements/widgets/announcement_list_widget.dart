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

  void goToAnnouncementPage(BuildContext context, String id) {
    var routemaster = Routemaster.of(context);
    routemaster.push('${routemaster.currentRoute}/announcements/$id');
  }

  @override
  Widget build(BuildContext context) {
    const double titleFontSize = 16;

    return Column(
      children: [
        const Text(
          "Recente aankondigingen",
        )
            .fontSize(titleFontSize)
            .fontWeight(FontWeight.w300)
            .textColor(Colors.blueGrey),
        SingleChildScrollView(
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
                        vertical: 8,
                        horizontal: 16,
                      ),
                    ),
                    onTap: () => goToAnnouncementPage(context, announcement.id),
                  );
                },
              )
              .toList()
              .toColumn(crossAxisAlignment: CrossAxisAlignment.stretch),
        ),
      ],
    );
  }
}
