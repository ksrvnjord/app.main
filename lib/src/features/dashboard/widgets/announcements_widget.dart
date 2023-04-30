import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:ksrvnjord_main_app/src/features/announcements/api/announcements.graphql.dart';
import 'package:ksrvnjord_main_app/src/features/announcements/api/announcements_provider.dart';
import 'package:ksrvnjord_main_app/src/features/announcements/widgets/announcement_widget.dart';
import 'package:ksrvnjord_main_app/src/features/dashboard/widgets/widget_header.dart';
import 'package:routemaster/routemaster.dart';
import 'package:styled_widget/styled_widget.dart';

class AnnouncementsWidget extends ConsumerWidget {
  const AnnouncementsWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final announcementsVal = ref.watch(announcementsProvider);

    return announcementsVal.when(
      data: (announcements) => [
        const WidgetHeader(title: "Recente aankondigingen"),
        announcements
            .map<Widget>(
              (announcement) => InkWell(
                child: AnnouncementWidget(
                  title: announcement.title,
                  subtitle:
                      "${announcement.author} - ${DateFormat.yMMMd().format(announcement.created_at)}",
                  text: '',
                  padding: const EdgeInsets.symmetric(
                    vertical: 2,
                  ),
                ),
                onTap: () => Routemaster.of(context)
                    .push('announcements/${announcement.id}'),
              ),
            )
            .toList()
            .toColumn(crossAxisAlignment: CrossAxisAlignment.stretch),
      ].toColumn(),
      error: (error, stackTrace) => Text(error.toString()),
      loading: () => const CircularProgressIndicator(),
    );
  }
}
