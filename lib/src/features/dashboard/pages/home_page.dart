import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ksrvnjord_main_app/assets/images.dart';
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
import 'package:ksrvnjord_main_app/src/features/shared/model/firebase_user_notifier.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/firebase_widget.dart';
import 'package:routemaster/routemaster.dart';
import 'package:styled_widget/styled_widget.dart';

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
    ref.invalidate(Announcements.firstPageProvider);

    // Wait for all providers to be updated.
    // ignore: avoid-ignoring-return-values
    await Future.wait([
      ref.watch(vaarverbodProvider.future),
      ref.watch(openPollsProvider.future),
      ref.watch(comingEventsProvider.future),
      ref.watch(Announcements.firstPageProvider.future),
    ]);
  }

  // Override didCHangeDependencies.
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // ignore: avoid-ignoring-return-values
    ref.watch(
      currentFirestoreUserProvider,
    ); // Init the current user with data from Firestore.
  }

  @override
  Widget build(BuildContext context) {
    const double elementPadding = 8;

    const double logoHeight = 56;
    const double myProfileSize = 26;

    double screenTopPadding = MediaQuery.of(context).padding.top;

    const double logoBottomPadding = 2;
    const double logoLeftPadding = 8;

    return Scaffold(
      appBar: PreferredSize(
        // ignore: sort_child_properties_last
        child: SizedBox(height: screenTopPadding),
        preferredSize: Size.fromHeight(screenTopPadding),
      ),
      body: RefreshIndicator(
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
                bottom: elementPadding + logoBottomPadding,
                left: logoLeftPadding,
              ), // To align logo with the ProfileIcon.
              FirebaseWidget(
                onAuthenticated: IconButton(
                  iconSize: myProfileSize,
                  onPressed: () => Routemaster.of(context).push('edit'),
                  icon: const MyProfilePicture(profileIconSize: myProfileSize),
                ),
              ),
            ].toRow(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
            ),
            const VaarverbodWidget().padding(all: elementPadding),
            FirebaseWidget(
              onAuthenticated:
                  const FormsWidget().padding(vertical: elementPadding),
            ),
            const ComingWeekEventsWidget().padding(vertical: elementPadding),
            const AnnouncementsWidget().padding(vertical: elementPadding),
          ],
        ),
        onRefresh: _refresh,
      ),
    );
  }
}
