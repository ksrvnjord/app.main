import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
<<<<<<< HEAD:lib/pages/main/announcements/announcements.dart
import 'package:ksrv_njord_app/pages/main/announcements/announcement.dart';
import 'package:ksrv_njord_app/providers/heimdall.dart';
import 'package:ksrv_njord_app/widgets/ui/general/loading.dart';

const String announcements = r'''
  query announcements {
    announcements(first: 10) {
      data {
        id,
        title
      }
    }
  }
''';
=======
import 'package:ksrvnjord_main_app/widgets/general/announcements.dart';
>>>>>>> c08bd18a5b9e11598e4aec292b3f357b5650b8b8:lib/pages/announcements.dart

double titleFontSize = 28;
double contentFontSize = 22;
double paddingBody = 10;

class AnnouncementsPage extends HookConsumerWidget {
  const AnnouncementsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
        appBar: AppBar(
            title: const Text('Aankondigingen'),
            backgroundColor: Colors.lightBlue,
            shadowColor: Colors.transparent,
            automaticallyImplyLeading: false,
            systemOverlayStyle:
                const SystemUiOverlayStyle(statusBarColor: Colors.lightBlue)),
<<<<<<< HEAD:lib/pages/main/announcements/announcements.dart
        body: FutureBuilder(
          future: result,
          builder: (BuildContext context, AsyncSnapshot<QueryResult> snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
                return const Text('not started');
              case ConnectionState.waiting:
                return const Loading();
              default:
                var announcementsList =
                    snapshot.data?.data?['announcements']['data'] ?? [];
                return Padding(
                  // Add padding to whole body
                  padding: EdgeInsets.all(paddingBody),
                  child: ListView.builder(
                    itemCount: announcementsList.length ?? 0,
                    itemBuilder: (context, index) {
                      return Card(
                        color: Colors.white,
                        elevation: 5, // give more card-like feel
                        child: ListTile(
                          title: Text(
                            announcementsList[index]['title'] ?? '',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AnnouncementPage(
                                      announcementId: announcementsList[index]
                                          ['id'])),
                            );
                          },
                        ),
                      );
                    },
                  ),
                );
            }
          },
        ));
=======
        body: const Announcements(amount: 10)); // show first 10 announcements
>>>>>>> c08bd18a5b9e11598e4aec292b3f357b5650b8b8:lib/pages/announcements.dart
  }
}
