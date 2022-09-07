import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:ksrvnjord_main_app/src/features/announcements/models/announcements.dart';
import 'package:ksrvnjord_main_app/src/features/announcements/widgets/announcement_list_widget.dart';
import 'package:ksrvnjord_main_app/src/features/shared/model/graphql_model.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/future_wrapper.dart';
import 'package:ksrvnjord_main_app/src/features/announcements/api/announcements.graphql.dart';

class AnnouncementsPage extends StatelessWidget {
  const AnnouncementsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var client = GetIt.I<GraphQLModel>().client;

    return Scaffold(
        appBar: AppBar(
          title: const Text('Aankondigingen'),
          leading: null,
          backgroundColor: Colors.lightBlue,
          shadowColor: Colors.transparent,
        ),
        body: FutureWrapper<Query$Announcements?>(
            future: announcements(0, client),
            success: (data) {
              if (data != null && data.announcements != null) {
                return AnnouncementListWidget(
                    announcements: data.announcements!.data);
              }
              return null;
            }));
  }
}
