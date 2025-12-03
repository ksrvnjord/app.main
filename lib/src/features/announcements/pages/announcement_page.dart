// ignore_for_file: prefer-extracting-callbacks, prefer-extracting-function-callbacks

import 'dart:async';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ksrvnjord_main_app/src/features/announcements/api/all_announcement_provider.dart';
import 'package:ksrvnjord_main_app/src/features/announcements/api/announcement_provider.dart';
import 'package:ksrvnjord_main_app/src/features/gallery/api/gallery_image_provider.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/api/user_provider.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/error_card_widget.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/error_text_widget.dart';
import 'package:url_launcher/url_launcher.dart';

/// A Page that displays a single image from the gallery.
/// This closely resembles [GalleryFilePage] from the announcements feature.
/// Any changes made here should be reflected there as well.

class AnnouncementPage extends ConsumerStatefulWidget {
  const AnnouncementPage({
    super.key,
    required this.initialIndex,
    required this.paths,
  });

  final int initialIndex;
  final List<Reference> paths;

  @override
  AnnouncementPageState createState() => AnnouncementPageState();
}

class AnnouncementPageState extends ConsumerState<AnnouncementPage> {
  int _currentPage = 0;
  PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    _currentPage = widget.initialIndex;
    _pageController = PageController(initialPage: widget.initialIndex);
    _preloadImage(ref, _currentPage);
    for (int i = 1; i < 4; i += 1) {
      _preloadImage(ref, _currentPage + i);
      _preloadImage(ref, _currentPage - i);
    }
  }

  void _preloadImage(WidgetRef ref, int index) {
    if (index < 0 || index >= widget.paths.length) {
      return;
    }
    final path = widget.paths[index];

    // Read from the provider and cache it if needed.
    final memoryImageFuture =
        ref.read(galleryImageProvider(path.fullPath).future);

    memoryImageFuture.then((image) {
      // Precache the image only if it's not in the cache already.
      if (!imageCache.containsKey(MemoryImage(image.bytes))) {
        if (mounted) {
          precacheImage(image, context).ignore();
        }
      }
    });
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
            decoration: const InputDecoration(
                labelText: 'Volledige link (https://...)'),
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
    final Reference path = widget.paths[_currentPage];
    final id = path.name.substring(0, path.name.indexOf('.'));
    final announcements = ref.read(allAnnouncementProvider);
    final announcementNotifier = ref.watch(allAnnouncementProvider.notifier);
    final index = announcements.indexWhere((a) => a.id == id);
    final currentUserAsyncValue = ref.read(currentUserProvider);
    final navigator = Navigator.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Aankondiging"),
        actions: [
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
                                onPressed: () =>
                                    Navigator.of(context).pop(false),
                                child: const Text('Nee'),
                              ),
                              TextButton(
                                onPressed: () =>
                                    Navigator.of(context).pop(true),
                                child: const Text('Ja'),
                              ),
                            ],
                          );
                        },
                      );

                      if (confirm == true) {
                        final announcement = announcements[index];
                        ref
                            .read(announcementProvider.notifier)
                            .deleteAnnouncement(announcement.id);

                        navigator.pop();
                      }
                    });
              } else {
                return const SizedBox.shrink();
              }
            },
            loading: () => const SizedBox.shrink(),
            error: (error, stackTrace) => ErrorCardWidget(
              errorMessage: error.toString(),
            ),
          ),
        ],
      ),
      body: GestureDetector(
        onTap: () {
          final url = announcements[index].link;
          if (url != null && url.isNotEmpty) {
            launchUrl(Uri.parse(url));
          }
        },
        onLongPress: () {
          currentUserAsyncValue.when(
            data: (currentUser) async {
              if (currentUser.isAdmin) {
                final announcement = announcements[index];
                final newLink = await _showEditLinkDialog(
                  context: context,
                  currentLink: announcement.link ?? "",
                );

                if (newLink != null && newLink != announcement.link) {
                  await announcementNotifier.updateAnnouncementLink(
                    announcement.id,
                    newLink,
                  );
                  setState(() {});
                }
              }
            },
            loading: () {},
            error: (err, trace) {},
          );
        },
        child: PageView.builder(
          controller: _pageController,
          onPageChanged: (index) {
            setState(() {
              bool isForward = _currentPage < index;
              _currentPage = index;
              _preloadImage(ref, isForward ? index + 3 : index - 3);
            });
          },
          itemBuilder: (context, index) {
            final Reference path = widget.paths[index];

            // Access the manual cache.
            final cache = ref.read(galleryImageCacheProvider);

            // Check if the image is in the cache.
            final image = cache[path.fullPath];

            if (image == null) {
              // Fallback: Use galleryImageProvider to load and cache the image.
              final imageVal = ref.watch(galleryImageProvider(path.fullPath));

              return imageVal.when(
                data: (loadedImage) {
                  // Add the newly loaded image to the cache.
                  cache[path.fullPath] = loadedImage;

                  return Image.memory(loadedImage.bytes);
                },
                error: (err, _) => Center(
                  child: ErrorTextWidget(
                    errorMessage: err.toString(),
                  ),
                ),
                loading: () =>
                    const Center(child: CircularProgressIndicator.adaptive()),
              );
            }

            // Render the cached image.
            return Image.memory(image.bytes);
          },
          itemCount: widget.paths.length,
        ),
        onHorizontalDragUpdate: (details) {
          if (details.primaryDelta! > 0) {
            if (_currentPage > 0) {
              _pageController.previousPage(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              );
            }
          } else if (details.primaryDelta! < 0) {
            if (_currentPage < widget.paths.length - 1) {
              _pageController.nextPage(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              );
            }
          }
        },
      ),
    );
  }
}
