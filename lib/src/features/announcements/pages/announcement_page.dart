import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ksrvnjord_main_app/src/features/announcements/api/announcement.graphql.dart';
import 'package:ksrvnjord_main_app/src/features/announcements/models/announcement.dart';
import 'package:ksrvnjord_main_app/src/features/announcements/widgets/announcement_body_widget.dart';
import 'package:ksrvnjord_main_app/src/features/shared/model/graphql_model.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/future_wrapper.dart';
import 'package:routemaster/routemaster.dart';

class AnnouncementPage extends ConsumerStatefulWidget {
  const AnnouncementPage({Key? key}) : super(key: key);

  @override
  createState() => _AnnouncementPageState();
}

class _AnnouncementPageState extends ConsumerState<AnnouncementPage> {
  String title = 'Bericht';

  @override
  Widget build(BuildContext context) {
    final client = ref.watch(graphQLModelProvider).client;
    var params = RouteData.of(context).pathParameters;

    return FutureWrapper<Query$Announcement$announcement?>(
      future: announcement(params['announcementId'] ?? '1', client),
      success: buildAnnouncementBody,
      loading: Scaffold(
        appBar: AppBar(
          title: const Text('Bericht'),
          shadowColor: Colors.transparent,
          backgroundColor: Colors.lightBlue,
          systemOverlayStyle:
              const SystemUiOverlayStyle(statusBarColor: Colors.lightBlue),
        ),
        body: const LinearProgressIndicator(),
      ),
    );
  }

  Widget buildAnnouncementBody(Query$Announcement$announcement? data) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Aankondiging'),
        shadowColor: Colors.transparent,
        backgroundColor: Colors.lightBlue,
        systemOverlayStyle:
            const SystemUiOverlayStyle(statusBarColor: Colors.lightBlue),
      ),
      body: (data != null)
          ? Padding(
              padding: const EdgeInsets.all(16),
              child: AnnouncementBodyWidget(
                title: data.title,
                text: data.contents,
              ),
            )
          : Container(),
    );
  }
}
