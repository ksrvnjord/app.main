import 'package:flutter/material.dart';
import 'package:ksrvnjord_main_app/src/features/announcements/api/announcements.graphql.dart';
import 'package:ksrvnjord_main_app/src/features/announcements/models/announcements.dart';
import 'package:ksrvnjord_main_app/src/features/announcements/widgets/announcement_list_widget.dart';
import 'package:ksrvnjord_main_app/src/features/announcements/widgets/announcement_widget.dart';
import 'package:ksrvnjord_main_app/src/features/shared/model/graphql_model.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/future_wrapper.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/shimmer_widget.dart';
import 'package:provider/provider.dart';
import 'package:styled_widget/styled_widget.dart';

class AnnouncementsHomeWidget extends StatelessWidget {
  const AnnouncementsHomeWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var client = Provider.of<GraphQLModel>(context).client;

    return FutureWrapper<Query$Announcements?>(
        future: announcements(0, client),
        success: (data) {
          if (data != null && data.announcements != null) {
            return AnnouncementListWidget(
                announcements: data.announcements!.data);
          }

          return null;
        },
        loading: [
          const ShimmerWidget(
                  child: AnnouncementWidget(
                      title: 'Loading', subtitle: 'Loading', text: ''))
              .padding(all: 15),
        ].toColumn());
  }
}
