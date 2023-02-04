import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ksrvnjord_main_app/assets/images.dart';
import 'package:ksrvnjord_main_app/src/features/dashboard/widgets/announcements_widget.dart';
import 'package:ksrvnjord_main_app/src/features/dashboard/widgets/vaarverbod_widget.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/logo_widget.dart';
import 'package:routemaster/routemaster.dart';
import 'package:styled_widget/styled_widget.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const double myAccountIconSize = 40;

    return Scaffold(
      appBar: AppBar(
        title: [
          const LogoWidget(image: Images.appLogo),
          IconButton(
            padding: const EdgeInsets.all(0),
            iconSize: myAccountIconSize,
            icon: const Icon(Icons.account_circle),
            onPressed: () {
              Routemaster.of(context).push('/settings');
            },
          ),
        ].toRow(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
        ),
        backgroundColor: Colors.lightBlue,
        shadowColor: Colors.transparent,
        systemOverlayStyle:
            const SystemUiOverlayStyle(statusBarColor: Colors.lightBlue),
      ),
      body: <Widget>[
        const VaarverbodWidget(),
        const AnnouncementsHomeWidget(),
      ].toColumn(),
    );
  }
}
