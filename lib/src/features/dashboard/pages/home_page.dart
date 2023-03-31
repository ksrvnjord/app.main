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
  static const double logoRightPadding = 16;

  @override
  Widget build(BuildContext context) {
    const double elementPadding = 4;

    final double logoSize =
        0.5 * MediaQuery.of(context).size.width; // half of the screen width

    return Scaffold(
      body: ListView(padding: const EdgeInsets.all(16), children: <Widget>[
        Container(
          padding: const EdgeInsets.only(top: 40),
          child: [
            Image.asset(
              Images.appLogoBlue,
              width: logoSize,
            ).padding(right: logoRightPadding),
            const VaarverbodWidget(),
          ].toRow(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
          ),
        ),
        const FormsWidget(),
        const ComingWeekEventsWidget().padding(vertical: elementPadding),
        const AnnouncementsWidget().padding(vertical: elementPadding),
      ]),
    );
  }
}

class FormsWidget extends StatelessWidget {
  const FormsWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return [
      [
        const Text(
          "Forms",
        )
            .fontSize(16)
            .fontWeight(FontWeight.w300)
            .textColor(Colors.blueGrey)
            .alignment(Alignment.center),
        GestureDetector(
          onTap: () => Routemaster.of(context).push('polls'),
          child: [
            const Text("Meer").textColor(Colors.blueGrey),
            const Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: Colors.blueGrey,
            ),
          ].toRow(
            mainAxisAlignment: MainAxisAlignment.end,
          ),
        ).alignment(Alignment.centerRight),
      ].toStack(),
      // TODO: show latest three forms
    ].toColumn();
  }
}
