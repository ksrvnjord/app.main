import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ksrvnjord_main_app/src/features/announcements/api/announcement_provider.dart';
import 'package:ksrvnjord_main_app/src/features/announcements/widgets/announcement_header_widget.dart';
import 'package:ksrvnjord_main_app/src/features/dashboard/widgets/announcement_page_widget.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class AnnouncementsWidget extends ConsumerStatefulWidget {
  const AnnouncementsWidget({super.key});

  @override
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

  @override
  Widget build(BuildContext context) {
    final announcements = ref.watch(announcementProvider);
    final screenHeigth = MediaQuery.of(context).size.height;

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
        else
          SizedBox(
            height: 16.0,
          ),
        SmoothPageIndicator(
            controller: _pageController,
            count: announcements.length,
            effect: WormEffect(
              dotHeight: 8.0,
              dotWidth: 8.0,
              spacing: 16.0,
              activeDotColor: Theme.of(context).colorScheme.secondary,
              dotColor: Colors.grey,
            )),
        SizedBox(
            height: screenHeigth,
            child: GestureDetector(
              onHorizontalDragUpdate: (details) {
                if (details.primaryDelta! > 0) {
                  _pageController.previousPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut);
                } else if (details.primaryDelta! < 0) {
                  _pageController.nextPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut);
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
            )),
      ],
    );
  }
}
