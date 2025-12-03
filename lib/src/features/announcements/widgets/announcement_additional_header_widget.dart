import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ksrvnjord_main_app/src/features/announcements/api/announcement_provider.dart';
import 'package:ksrvnjord_main_app/src/features/announcements/api/get_image.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/api/user_provider.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/error_card_widget.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/error_text_widget.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:ksrvnjord_main_app/src/features/announcements/model/announcement.dart';

class AnnouncementAdditionalHeaderWidget extends ConsumerWidget {
  const AnnouncementAdditionalHeaderWidget({
    super.key,
    required this.pageController,
    required this.announcements,
  });

  final PageController pageController;
  final List<Announcement> announcements;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUserAsyncValue = ref.watch(currentUserProvider);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        currentUserAsyncValue.when(
          data: (currentUser) {
            if (currentUser.isAdmin) {
              return IconButton(
                  icon: const Icon(Icons.add, color: Colors.grey),
                  onPressed: () {
                    pickImage(context, ref, currentUser.identifier.toString());
                  });
            } else {
              return const SizedBox(width: 48);
            }
          },
          loading: () => const SizedBox(width: 48),
          error: (error, stackTrace) => ErrorTextWidget(
            errorMessage: error.toString(),
          ),
        ),
        SmoothPageIndicator(
          controller: pageController,
          count: announcements.length,
          effect: WormEffect(
            dotHeight: 8.0,
            dotWidth: 8.0,
            spacing: 16.0,
            activeDotColor: Theme.of(context).colorScheme.secondary,
            dotColor: Colors.grey,
          ),
        ),
        currentUserAsyncValue.when(
          data: (currentUser) {
            if (currentUser.isAdmin) {
              return IconButton(
                  icon: const Icon(Icons.delete, color: Colors.grey),
                  onPressed: () async {
                    final confirm = await showDialog<bool>(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text('Verwijder aankondiging'),
                          content: const Text(
                              'Weet je zeker dat je de aankondiging wil verwijderen?'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(false),
                              child: const Text('Nee'),
                            ),
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(true),
                              child: const Text('Ja'),
                            ),
                          ],
                        );
                      },
                    );

                    if (confirm == true) {
                      double? currentPage = pageController.page;
                      if (currentPage != null) {
                        final announcement = announcements[currentPage.toInt()];
                        ref
                            .read(announcementProvider.notifier)
                            .deleteAnnouncement(announcement.id);
                      }
                    }
                  });
            } else {
              return const SizedBox(width: 48);
            }
          },
          loading: () => const SizedBox(width: 48),
          error: (error, stackTrace) => ErrorCardWidget(
            errorMessage: error.toString(),
          ),
        ),
      ],
    );
  }
}
