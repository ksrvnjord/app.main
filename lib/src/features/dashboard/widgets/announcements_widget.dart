import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ksrvnjord_main_app/src/features/announcements/api/announcement_provider.dart';
import 'package:ksrvnjord_main_app/src/features/announcements/widgets/announcement_header_widget.dart';
import 'package:ksrvnjord_main_app/src/features/dashboard/widgets/announcement_page_widget.dart';
import 'package:ksrvnjord_main_app/src/features/dashboard/widgets/announcement_additional_header_widget.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/api/user_provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

class AnnouncementsWidget extends ConsumerStatefulWidget {
  const AnnouncementsWidget({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _AnnouncementsWidgetState createState() => _AnnouncementsWidgetState();
}

class _AnnouncementsWidgetState extends ConsumerState<AnnouncementsWidget> {
  late PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentPage);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<String?> _showEditLinkDialog({
    required BuildContext context,
    required String currentLink,
  }) {
    final TextEditingController controller =
        TextEditingController(text: currentLink);

    return showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Link aanpassen'),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(labelText: 'Link'),
          ),
          actions: [
            TextButton(
              onPressed: () =>
                  Navigator.of(context).pop(null), // Return null on cancel
              child: const Text('Terug'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context)
                  .pop(controller.text), // Return the updated link
              child: const Text('Opslaan'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final announcements = ref.watch(announcementProvider);
    final announcementNotifier = ref.read(announcementProvider.notifier);
    final screenHeigth = MediaQuery.of(context).size.height;
    final currentUserAsyncValue = ref.watch(currentUserProvider);

    return currentUserAsyncValue.when(
      data: (currentUser) {
        return Column(
          children: [
            AnnouncementHeaderWidget(),
            if (announcements.isEmpty)
              const SizedBox(
                height: 320,
                child: Center(
                  child: Text(
                    "Er zijn geen recente aankondigingen",
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                ),
              )
            else ...[
              SizedBox(
                height: 16.0,
              ),
              AnnouncementAdditionalHeaderWidget(
                pageController: _pageController,
                announcements: announcements,
              ),
              SizedBox(
                height: screenHeigth,
                child: GestureDetector(
                  onTap: () {
                    final url = announcements[_currentPage].link;
                    if (url != null && url.isNotEmpty) {
                      launchUrl(Uri.parse(url));
                    }
                  },
                  onLongPress: () async {
                    if (currentUser.isAdmin) {
                      final announcement = announcements[_currentPage];
                      final newLink = await _showEditLinkDialog(
                        context: context,
                        currentLink: announcement.link ?? "",
                      );

                      if (newLink != null && newLink != announcement.link) {
                        announcementNotifier.updateAnnouncementLink(
                          announcement.id,
                          newLink,
                        );
                      }
                    }
                  },
                  onHorizontalDragUpdate: (details) {
                    if (details.primaryDelta! > 0) {
                      _pageController.previousPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    } else if (details.primaryDelta! < 0) {
                      _pageController.nextPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    }
                  },
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: announcements.length,
                    onPageChanged: (index) {
                      setState(() {
                        _currentPage = index;
                      });
                    },
                    itemBuilder: (context, index) {
                      final announcement = announcements[index];
                      return AnnouncementPageWidget(announcement: announcement);
                    },
                  ),
                ),
              ),
            ],
          ],
        );
      },
      loading: () => const Center(
        child: CircularProgressIndicator(),
      ),
      error: (error, stackTrace) => ErrorWidget(error),
    );
  }
}
