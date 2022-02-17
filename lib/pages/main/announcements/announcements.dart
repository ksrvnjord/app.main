import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ksrvnjord_main_app/pages/main/announcements/add_announcement.dart';
import 'package:ksrvnjord_main_app/widgets/general/announcements.dart';

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
        body: const Announcements(amount: 10),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            // Go to the AddAnnouncementPage
            Navigator.push(
              context, 
              MaterialPageRoute(
                builder:(context) => const AddAnnouncementPage()
              ),
              );
          },
          backgroundColor: Colors.lightBlue,
          child: const Icon(Icons.add),
        )); // show first 10 announcements
  }
}
