import 'package:flutter/material.dart';
import 'package:ksrvnjord_main_app/assets/images.dart';
import 'package:ksrvnjord_main_app/src/features/dashboard/widgets/announcements_widget.dart';
import 'package:ksrvnjord_main_app/src/features/dashboard/widgets/forms_widget.dart';
import 'package:ksrvnjord_main_app/src/features/dashboard/widgets/vaarverbod_widget.dart';
import 'package:ksrvnjord_main_app/src/features/events/widgets/coming_week_events_widget.dart';
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
      appBar: PreferredSize(
        // this is to make the body start below the status bar
        preferredSize: Size.fromHeight(MediaQuery.of(context).padding.top),
        child: SizedBox(
          height: MediaQuery.of(context).padding.top,
        ),
      ),
      body: ListView(padding: const EdgeInsets.all(16), children: <Widget>[
        Container(
          padding: const EdgeInsets.only(top: 16),
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
        const FormsWidget().padding(vertical: elementPadding),
        const ComingWeekEventsWidget().padding(vertical: elementPadding),
        const AnnouncementsWidget().padding(vertical: elementPadding),
      ]),
    );
  }
}
