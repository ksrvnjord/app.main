import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ksrvnjord_main_app/src/features/announcements/api/announcements.dart';
import 'package:ksrvnjord_main_app/src/features/announcements/widgets/announcement_body_widget.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/error_card_widget.dart';
import 'package:routemaster/routemaster.dart';
import 'package:styled_widget/styled_widget.dart';

class AnnouncementPage extends ConsumerWidget {
  const AnnouncementPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final announcementValue = ref.watch(Announcements.getByIdProvider(
      RouteData.of(context).pathParameters['announcementId'] ?? '1',
    ));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Aankondiging'),
      ),
      body: announcementValue.when(
        data: (data) =>
            AnnouncementBodyWidget(title: data.title, text: data.contents),
        error: (err, stk) => ErrorCardWidget(errorMessage: err.toString()),
        loading: () => const CircularProgressIndicator().center(),
      ),
    );
  }
}
