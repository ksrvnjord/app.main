import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ksrvnjord_main_app/src/features/announcements/api/announcements_provider.dart';
import 'package:ksrvnjord_main_app/src/features/dashboard/widgets/widget_header.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/error_card_widget.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/shimmer_widget.dart';
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
    const double shimmerContainerHeight = 320;

    return [
      const WidgetHeader(title: "Recente aankondigingen"),
      announcementsVal.when(
        data: (announcements) => announcements
            .map(
              (announcement) => ListTile(
                title: Text(announcement.title),
                subtitle: Text.rich(TextSpan(children: [
                  TextSpan(text: "${announcement.author} ")
                      .textColor(Colors.black54)
                      .fontSize(announcementSubtitleFontSize)
                      .fontWeight(FontWeight.bold),
                  TextSpan(
                    text: timeago.format(announcement.created_at, locale: 'nl'),
                  )
                      .textColor(Colors.grey)
                      .fontSize(announcementSubtitleFontSize),
                ])),
                trailing: [
                  const Icon(Icons.chevron_right, color: Colors.blueGrey),
                ].toColumn(mainAxisAlignment: MainAxisAlignment.center),
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(16)),
                ),
                // ignore: prefer-extracting-callbacks
                onTap: () {
                  FirebaseAnalytics.instance.logEvent(
                    name: 'announcement_opened',
                    parameters: {
                      'announcement_id': announcement.id,
                      'announcement_title': announcement.title,
                    },
                  );
                  Routemaster.of(context)
                      .push('announcements/${announcement.id}');
                },
                minLeadingWidth: minLeadingWidth,
              ),
            )
            .toList()
            .toColumn(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              separator: const Divider(
                height: 1,
              ),
            ),
        error: (error, stackTrace) =>
            ErrorCardWidget(errorMessage: error.toString()),
        loading: () => ShimmerWidget(
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(16)),
            ),
            height: shimmerContainerHeight,
          ),
        ),
      ),
    ].toColumn();
  }
}
