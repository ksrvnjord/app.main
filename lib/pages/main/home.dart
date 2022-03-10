import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ksrvnjord_main_app/assets/images.dart';
import 'package:ksrvnjord_main_app/widgets/general/agenda_icon.dart';
import 'package:ksrvnjord_main_app/widgets/general/announcements.dart';
import 'package:ksrvnjord_main_app/widgets/general/vaarverbod.dart';
import 'package:ksrvnjord_main_app/widgets/general/myprofile.dart';
import 'package:ksrvnjord_main_app/widgets/images/bar_logo.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          // TODO: Have the title with only the Logo, and size it correctly
          title: Row(
              children: const <Widget>[
                AgendaCard(),
                BarLogoWidget(image: Images.appLogo),
                // TODO: Rewrite this Row-construction to AppBar(..., actions: [])
                MyProfileCard()
              ],
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center),
          automaticallyImplyLeading: false,
          backgroundColor: Colors.lightBlue,
          shadowColor: Colors.transparent,
          systemOverlayStyle:
              const SystemUiOverlayStyle(statusBarColor: Colors.lightBlue)),
      body: ListView(
        // TODO: ListView should be inside a Padding element instead of padding each child of listView separately
        shrinkWrap: true,
        children: <Widget>[
          Center(child: Column(children: const [VaarverbodWidget()])),
          const Announcements(amount: 3),
          GridView.count(
              crossAxisCount: 2,
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              children: const <Widget>[]),
        ],
      ),
    );
  }
}
