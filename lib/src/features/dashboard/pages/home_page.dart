import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ksrvnjord_main_app/assets/images.dart';
import 'package:ksrvnjord_main_app/assets/lustrum_colors.dart';
import 'package:ksrvnjord_main_app/assets/svgs.dart';
import 'package:ksrvnjord_main_app/src/features/announcements/api/announcements.dart';
import 'package:ksrvnjord_main_app/src/features/dashboard/api/vaarverbod_provider.dart';
import 'package:ksrvnjord_main_app/src/features/dashboard/widgets/announcements_widget.dart';
import 'package:ksrvnjord_main_app/src/features/dashboard/widgets/forms_widget.dart';
import 'package:ksrvnjord_main_app/src/features/dashboard/widgets/vaarverbod_widget.dart';
import 'package:ksrvnjord_main_app/src/features/events/api/events_provider.dart';
import 'package:ksrvnjord_main_app/src/features/events/widgets/coming_week_events_widget.dart';
import 'package:ksrvnjord_main_app/src/features/polls/api/poll_answer_provider.dart';
import 'package:ksrvnjord_main_app/src/features/polls/api/polls_provider.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/widgets/my_profile_picture.dart';
import 'package:ksrvnjord_main_app/src/features/shared/api/firebase_currentuser_provider.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/firebase_widget.dart';
import 'package:routemaster/routemaster.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:tuple/tuple.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  Future<void> _refresh() async {
    // Invalidate all providers for the widgets on the home page.
    ref.invalidate(firebaseAuthUserProvider);
    ref.invalidate(vaarverbodProvider);
    ref.invalidate(openPollsProvider);
    ref.invalidate(pollAnswerProvider);
    ref.invalidate(comingEventsProvider);
    ref.invalidate(Announcements.firstTenProvider);

    // Wait for all providers to be updated.
    // ignore: avoid-ignoring-return-values
    await Future.wait([
      ref.watch(vaarverbodProvider.future),
      ref.watch(openPollsProvider.future),
      ref.watch(comingEventsProvider.future),
      ref.watch(Announcements.firstTenProvider.future),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    const double elementVPadding = 16;
    const double elementHPadding = 8;

    const double logoHeight = 56;
    const double myProfileSize = 26;

    double screenTopPadding = MediaQuery.of(context).padding.top;

    const double logoLeftPadding = 8;

    const double bottomPaddingLogo = 10; // To align logo with the ProfileIcon.

    const double indent = 56;
    const endIndent = indent;
    const double vaarverbodTopPadding = 4;
    final colorScheme = Theme.of(context).colorScheme;

    const double dividerThickness = 4;

    return Scaffold(
      appBar: PreferredSize(
        // ignore: sort_child_properties_last
        child: SizedBox(height: screenTopPadding),
        preferredSize: Size.fromHeight(screenTopPadding),
      ),
      body: CustomPaint(
        painter: BackgroundPainter(context: context),
        child: RefreshIndicator(
          // ignore: sort_child_properties_last
          child: ListView(
            padding: const EdgeInsets.only(bottom: 80),
            children: <Widget>[
              [
                Image.asset(
                  Theme.of(context).brightness == Brightness.light
                      ? Images.appLogoBlue
                      : Images.appLogo,
                  height: logoHeight,
                ).padding(
                  bottom: bottomPaddingLogo,
                  left: logoLeftPadding,
                ), // To align logo with the ProfileIcon.
                FirebaseWidget(
                  onAuthenticated: IconButton(
                    iconSize: myProfileSize,
                    onPressed: () => Routemaster.of(context).push('my-profile'),
                    icon:
                        const MyProfilePicture(profileIconSize: myProfileSize),
                  ),
                ),
              ].toRow(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
              ),
              const VaarverbodWidget().padding(
                top: vaarverbodTopPadding,
                horizontal: elementHPadding,
              ),
              FirebaseWidget(
                onAuthenticated: const FormsWidget().padding(
                  vertical: elementVPadding,
                  horizontal: elementHPadding,
                ),
              ),
              const SwanDivider(),
              const ComingWeekEventsWidget().padding(vertical: elementVPadding),
              const SwanDivider(),
              const AnnouncementsWidget().padding(vertical: elementVPadding),
            ],
          ),
          onRefresh: _refresh,
        ),
      ),
    );
  }
}

class BackgroundPainter extends CustomPainter {
  final double offset;
  BuildContext context;

  BackgroundPainter({
    this.offset = 0,
    required this.context,
  });

  @override
  void paint(Canvas canvas, Size size) {
    var opacity = 0.16;
    final orange = Paint()
      ..color = LustrumColors.secondaryOrange.withOpacity(opacity)
      ..strokeWidth = 20.0;

    final blue = Paint()
      ..color = LustrumColors.lightBlue.withOpacity(opacity)
      ..strokeWidth = 20.0;

    canvas.drawLine(Offset(size.width * (1.0 + offset) + 10, 0),
        Offset(0, size.height * (1.0 + offset)), orange);

    canvas.drawLine(Offset(size.width * (1.0 + 0.1) + 10, 0),
        Offset(0, size.height * (1.0 + 0.1)), blue);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

class SwanDivider extends StatelessWidget {
  const SwanDivider({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return [
      for (final Tuple2<double, Color> color in [
        Tuple2(12, colorScheme.tertiaryContainer),
        Tuple2(16, colorScheme.primary),
        Tuple2(12, colorScheme.secondaryContainer),
      ])
        SvgPicture.asset(
          Svgs.swanWhite,
          width: color.item1,
          // ignore: deprecated_member_use
          color: color.item2,
        ),
    ].toRow(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      separator: const SizedBox(width: 8),
    );
  }
}
