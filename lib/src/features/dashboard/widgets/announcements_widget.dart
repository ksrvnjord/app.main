import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ksrvnjord_main_app/src/features/announcements/api/announcements.dart';
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
    final announcementsVal = ref.watch(Announcements.firstPageProvider);
    const double minLeadingWidth = 8;
    const double shimmerContainerHeight = 320;
    final textTheme = Theme.of(context).textTheme;

    return [
      const WidgetHeader(
        title: "Aankondigingen",
        titleIcon: Icons.campaign,
      ),
      announcementsVal.when(
        data: (announcements) => announcements == null
            ? const Text("Geen aankondigingen gevonden")
            : announcements
                .map(
                  (announcement) {
                    return ListTile(
                      title: Text(
                        announcement.title,
                      ),
                      subtitle: Text.rich(TextSpan(children: [
                        TextSpan(
                          text: "${announcement.author} ",
                          style: textTheme.labelMedium,
                        ),
                        TextSpan(
                          text: timeago.format(
                            announcement.created_at,
                            locale: 'nl',
                          ),
                          style: textTheme.labelMedium,
                        ).textColor(Theme.of(context).colorScheme.secondary),
                      ])),
                      trailing: [
                        const Icon(Icons.chevron_right),
                      ].toColumn(mainAxisAlignment: MainAxisAlignment.center),
                      // ignore: prefer-extracting-callbacks
                      onTap: () {
                        FirebaseAnalytics.instance.logEvent(
                          name: 'announcement_opened',
                          parameters: {
                            'announcement_id': announcement.id,
                            'announcement_title': announcement.title,
                          },
                        );
                        // ignore: avoid-ignoring-return-values
                        Routemaster.of(context)
                            .push('announcements/${announcement.id}');
                      },
                      minLeadingWidth: minLeadingWidth,
                    );
                  },
                )
                .toList()
                .toColumn(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                ),
        error: (error, stackTrace) =>
            ErrorCardWidget(errorMessage: error.toString()),
        loading: () => ShimmerWidget(
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(12)),
            ),
            height: shimmerContainerHeight,
          ),
        ),
      ),
    ].toColumn();
  }
}
