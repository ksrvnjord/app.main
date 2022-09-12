import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ksrvnjord_main_app/src/features/announcements/api/announcement.graphql.dart';
import 'package:ksrvnjord_main_app/src/features/announcements/models/announcement.dart';
import 'package:ksrvnjord_main_app/src/features/announcements/widgets/announcement_body_widget.dart';
import 'package:ksrvnjord_main_app/src/features/shared/model/graphql_model.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/future_wrapper.dart';
import 'package:provider/provider.dart';
import 'package:routemaster/routemaster.dart';

class AnnouncementPage extends StatefulWidget {
  const AnnouncementPage({Key? key}) : super(key: key);

  @override
  createState() => _AnnouncementPageState();
}

class _AnnouncementPageState extends State<AnnouncementPage> {
  String title = 'Bericht';

  @override
  Widget build(BuildContext context) {
    var client = Provider.of<GraphQLModel>(context).client;
    var params = RouteData.of(context).pathParameters;

    return FutureWrapper<Query$Announcement$announcement?>(
        future: announcement(params['announcementId'] ?? '1', client),
        success: (Query$Announcement$announcement? data) {
          return Scaffold(
              appBar: AppBar(
                title: Text((data != null) ? data.title : 'Bericht'),
                backgroundColor: Colors.lightBlue,
                shadowColor: Colors.transparent,
                systemOverlayStyle: const SystemUiOverlayStyle(
                    statusBarColor: Colors.lightBlue),
              ),
              body: (data != null)
                  ? AnnouncementBodyWidget(
                      title: data.title,
                      text: data.contents,
                    )
                  : Container());
        },
        loading: Scaffold(
            appBar: AppBar(
              title: const Text('Bericht'),
              backgroundColor: Colors.lightBlue,
              shadowColor: Colors.transparent,
              systemOverlayStyle:
                  const SystemUiOverlayStyle(statusBarColor: Colors.lightBlue),
            ),
            body: const LinearProgressIndicator()));
  }
}
