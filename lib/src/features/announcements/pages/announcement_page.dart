import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ksrvnjord_main_app/src/features/announcements/api/announcements.dart';
import 'package:ksrvnjord_main_app/src/features/announcements/widgets/announcement_body_widget.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/error_card_widget.dart';
import 'package:styled_widget/styled_widget.dart';

class AnnouncementPage extends ConsumerWidget {
  const AnnouncementPage({super.key, required this.announcementId});

  final String announcementId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final announcementValue =
        ref.watch(Announcements.byIdProvider(announcementId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Aankondiging'),
      ),
      body: announcementValue.when(
        data: (snapshot) {
          // ignore: avoid-non-null-assertion
          final announcement = snapshot.data();
          if (announcement == null) {
            return const ErrorCardWidget(
              errorMessage: 'Aankondiging niet gevonden',
            );
          }

          return AnnouncementBodyWidget(
            title: announcement.title,
            text: announcement.contents,
          );
        },
        error: (err, stk) => ErrorCardWidget(errorMessage: err.toString()),
        loading: () => const CircularProgressIndicator.adaptive().center(),
      ),
    );
  }
}
