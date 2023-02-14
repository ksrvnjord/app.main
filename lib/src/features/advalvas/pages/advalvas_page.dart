import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ksrvnjord_main_app/src/features/announcements/pages/announcements_page.dart';
import 'package:routemaster/routemaster.dart';
import 'package:styled_widget/styled_widget.dart';

class AdValvasPage extends StatelessWidget {
  const AdValvasPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const double padding = 25;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ad Valvas'),
        backgroundColor: Colors.lightBlue,
        shadowColor: Colors.transparent,
        automaticallyImplyLeading: false,
        systemOverlayStyle:
            const SystemUiOverlayStyle(statusBarColor: Colors.lightBlue),
      ),
      body: ListView(children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
          Ink(
            decoration: const ShapeDecoration(
              color: Colors.blue,
              shape: CircleBorder(),
            ),
            child: IconButton(
              color: Colors.white,
              icon: const Icon(Icons.calendar_month),
              onPressed: () {
                Routemaster.of(context).push('/ad-valvas/events');
              },
            ),
          ),
        ]).padding(all: padding),
        const Divider(
          indent: 50,
          endIndent: 50,
        ),
        const AnnouncementsPage(),
      ]),
    );
  }
}
