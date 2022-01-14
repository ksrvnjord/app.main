import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ksrvnjord_main_app/assets/images.dart';
import 'package:ksrvnjord_main_app/widgets/general/vaarverbod.dart';
import 'package:ksrvnjord_main_app/widgets/images/bar_logo.dart';
import 'package:ksrvnjord_main_app/pages/announcements.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const BarLogoWidget(image: Images.appLogo),
          automaticallyImplyLeading: false,
          backgroundColor: Colors.lightBlue,
          shadowColor: Colors.transparent,
          systemOverlayStyle:
              const SystemUiOverlayStyle(statusBarColor: Colors.lightBlue)),
      body: ListView(
        shrinkWrap: true,
        children: <Widget>[
          Center(child: Column(children: const [VaarverbodWidget()])),
          const Announcements(amount: 3)
        ],
      ),
    );
  }
}
