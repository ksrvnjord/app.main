import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ksrvnjord_main_app/src/features/dashboard/widgets/widget_header.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/api/user_provider.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/error_text_widget.dart';

class AnnouncementHeaderWidget extends ConsumerWidget {
  const AnnouncementHeaderWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(currentUserProvider);

    return currentUser.when(
      data: (user) {
        return WidgetHeader(
          title: "Aankondigingen",
          titleIcon: Icons.campaign,
          onTapName: "Alle aankondigingen",
          onTap: () => context.pushNamed("All Announcements"),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator.adaptive()),
      error: (err, stack) => ErrorTextWidget(
        errorMessage: err.toString(),
      ),
    );
  }
}
