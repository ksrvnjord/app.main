import 'package:flutter/material.dart';
import 'package:ksrvnjord_main_app/assets/images.dart';
import 'package:ksrvnjord_main_app/src/features/dashboard/widgets/announcements_widget.dart';
import 'package:ksrvnjord_main_app/src/features/dashboard/widgets/vaarverbod_widget.dart';
import 'package:ksrvnjord_main_app/src/features/events/widgets/coming_week_events_widget.dart';
import 'package:routemaster/routemaster.dart';
import 'package:styled_widget/styled_widget.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  static const double formsIconRightPadding = 8;

  @override
  Widget build(BuildContext context) {
    const double elementPadding = 4;

    final double logoSize =
        0.5 * MediaQuery.of(context).size.width; // half of the screen width

    return Scaffold(
      body: ListView(padding: const EdgeInsets.all(16), children: <Widget>[
        Container(
          margin: const EdgeInsets.only(top: 40),
          child: [
            Image.asset(
              Images.appLogoBlue,
              width: logoSize,
            ).padding(right: 8),
            const VaarverbodWidget().expanded(),
          ].toRow(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
          ),
        ),
        MaterialButton(
          elevation: 0,
          color: Colors.lightBlue,
          shape: // rounding
              const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(16)),
          ),
          child: [
            // icon for filling form
            const Icon(
              Icons.assignment,
              color: Colors.white,
            ).padding(right: formsIconRightPadding),
            const Text("Forms").textColor(Colors.white),
          ].toRow(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
          ),
          onPressed: () => Routemaster.of(context).push('polls'),
        ),
        const ComingWeekEventsWidget().padding(vertical: elementPadding),
        const AnnouncementsWidget().padding(vertical: elementPadding),
      ]),
    );
  }
}
