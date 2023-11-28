import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ksrvnjord_main_app/assets/images.dart';
import 'package:ksrvnjord_main_app/src/features/announcements/api/announcements.dart';
import 'package:ksrvnjord_main_app/src/features/dashboard/api/vaarverbod_provider.dart';
import 'package:ksrvnjord_main_app/src/features/dashboard/widgets/announcements_widget.dart';
import 'package:ksrvnjord_main_app/src/features/dashboard/widgets/forms_widget.dart';
import 'package:ksrvnjord_main_app/src/features/dashboard/widgets/lustrum_background_widget.dart';
import 'package:ksrvnjord_main_app/src/features/dashboard/widgets/swan_divider.dart';
import 'package:ksrvnjord_main_app/src/features/dashboard/widgets/vaarverbod_widget.dart';
import 'package:ksrvnjord_main_app/src/features/events/widgets/coming_week_events_widget.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/widgets/my_profile_picture.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/firebase_widget.dart';
import 'package:styled_widget/styled_widget.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  /// We only need to refresh providers that we don't listen to through a stream.
  Future<void> _refresh() async {
    final futureProviders = [
      vaarverbodProvider,
    ];

    final autoDisposeFutureProviders = [
      Announcements.firstTenProvider,
    ];

    for (final provider in autoDisposeFutureProviders) {
      ref.invalidate(provider);
    }
    for (final provider in futureProviders) {
      ref.invalidate(provider);
    }

    // ignore: avoid-ignoring-return-values
    await Future.wait([
      for (final p in autoDisposeFutureProviders) ref.watch(p.future),
      for (final FutureProvider provider in futureProviders)
        ref.watch(provider.future),
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

    const double vaarverbodTopPadding = 4;
    const pageOffset = 57.0;

    return Scaffold(
      // ignore: arguments-ordering
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(screenTopPadding),
        child: SizedBox(height: screenTopPadding),
      ),
      body: CustomPaint(
        painter: LustrumBackgroundWidget(
          screenSize: MediaQuery.of(context).size,
          pageOffset: pageOffset,
        ),
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
                    onPressed: () => context.goNamed("Edit Profile"),
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
                ),
              ),
              const SwanDivider(),
              FirebaseWidget(
                onAuthenticated: const ComingWeekEventsWidget().padding(
                  vertical: elementVPadding,
                ),
              ),
              const SwanDivider(),
              FirebaseWidget(
                onAuthenticated: const AnnouncementsWidget().padding(
                  vertical: elementVPadding,
                ),
              ),
            ],
          ),
          onRefresh: _refresh,
        ),
      ),
    );
  }
}
