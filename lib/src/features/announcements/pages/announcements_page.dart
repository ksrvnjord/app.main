import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:ksrvnjord_main_app/src/features/announcements/models/announcements.dart';
import 'package:ksrvnjord_main_app/src/features/shared/model/graphql_model.dart';
import 'package:ksrvnjord_main_app/src/features/shared/presentation/future_wrapper.dart';
import 'package:provider/provider.dart';

import '../api/announcements.graphql.dart';

class AnnouncementsPage extends StatelessWidget {
  const AnnouncementsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var client = GetIt.I<GraphQLModel>().client;

    return client != null
        ? Scaffold(
            appBar: AppBar(
              title: const Text('Aankondigingen'),
              backgroundColor: Colors.lightBlue,
              shadowColor: Colors.transparent,
            ),
            body: FutureWrapper<Query$Announcements?>(
                future: announcements(0, client),
                success: (data) {
                  return Text(data.toString());
                }))
        : Container();
  }
}
