import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ksrvnjord_main_app/src/features/announcements/api/announcements_provider.dart';
import 'package:ksrvnjord_main_app/src/features/dashboard/widgets/widget_header.dart';
import 'package:routemaster/routemaster.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:timeago/timeago.dart' as timeago;

class AnnouncementsWidget extends ConsumerWidget {
  const AnnouncementsWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final announcementsVal = ref.watch(announcementsProvider);
    const double minLeadingWidth = 8;
    const double announcementSubtitleFontSize = 12;

    return announcementsVal.when(
      data: (announcements) => [
        const WidgetHeader(title: "Recente aankondigingen"),
        announcements
            .map<Widget>(
              (announcement) => ListTile(
                title: Text(announcement.title),
                subtitle: Text(
                  "${announcement.author} - ${timeago.format(announcement.created_at, locale: 'nl')}",
                ).fontSize(announcementSubtitleFontSize),
                shape: // circular border
                    const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(16)),
                ),
                // tileColor: Colors.white,
                trailing: [const Icon(Icons.chevron_right)]
                    .toColumn(mainAxisAlignment: MainAxisAlignment.center),
                minLeadingWidth: minLeadingWidth,
                onTap: () => Routemaster.of(context)
                    .push('announcements/${announcement.id}'),
              ),
            )
            .toList()
            .toColumn(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              separator: const Divider(
                height: 1,
              ),
            ),
      ].toColumn(),
      error: (error, stackTrace) => Text(error.toString()),
      loading: () => const CircularProgressIndicator(),
    );
  }
}
