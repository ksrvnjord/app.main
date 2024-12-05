// ignore_for_file: prefer-extracting-callbacks, prefer-extracting-function-callbacks

import 'dart:async';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ksrvnjord_main_app/src/features/gallery/api/gallery_image_provider.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'dart:html' as html;

class GalleryFilePageView extends ConsumerStatefulWidget {
  const GalleryFilePageView({
    super.key,
    required this.initialIndex,
    required this.paths,
  });
  final int initialIndex;
  final List<Reference> paths;

  @override
  _GalleryFilePageViewState createState() => _GalleryFilePageViewState();
}

class _GalleryFilePageViewState extends ConsumerState<GalleryFilePageView> {
  int _currentPage = 0;
  PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    _currentPage = widget.initialIndex;
    _pageController = PageController(initialPage: widget.initialIndex);
  }

  void _preloadImages(int index) {
    // Preload 5 images before and after the current page index.
    for (int i = index - 5; i <= index + 5; i += 1) {
      if (i >= 0 && i < widget.paths.length) {
        final path = widget.paths[i];
        final imageVal = ref.watch(galleryImageProvider(path.fullPath));
        imageVal.when(
          data: (image) {
            // Preload the image using Image.memory.
            precacheImage(MemoryImage(image.bytes), context);
          },
          error: (err, _) {},
          loading: () {},
        );
      }
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Preload images around the current page once dependencies are resolved.
    _preloadImages(_currentPage);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Gallery"),
        actions: [
          // Share Button.
          IconButton(
            onPressed: () {
              final path = widget.paths.elementAtOrNull(_currentPage);
              if (path != null) {
                final imageVal = ref.watch(galleryImageProvider(path.fullPath));

                imageVal.when(
                  data: (image) {
                    if (kIsWeb) {
                      // Handle sharing on web or other platforms if needed.
                    } else {
                      Share.shareXFiles(
                        [
                          XFile.fromData(
                            image.bytes,
                            mimeType: "image/jpeg",
                            name: "${path.fullPath}.jpg",
                          ),
                        ],
                        subject: "Foto",
                      ).ignore();
                    }
                  },
                  error: (err, _) {},
                  loading: () {},
                );
              }
            },
            icon: const Icon(Icons.share),
          ),
          IconButton(
            onPressed: () {
              final path = widget.paths.elementAtOrNull(_currentPage);
              if (path != null) {
                final imageVal = ref.watch(galleryImageProvider(path.fullPath));

                imageVal.when(
                  data: (image) async {
                    if (kIsWeb) {
                      // Web-specific download logic.
                      final blob = html.Blob([image.bytes]);
                      final url = html.Url.createObjectUrlFromBlob(blob);
                      final anchor = html.AnchorElement(href: url)
                        ..target = 'blank'
                        ..download = 'foto_$_currentPage.jpg';
                      anchor.click();
                      html.Url.revokeObjectUrl(url);
                    } else {
                      // Mobile or Desktop-specific download logic using XFile.
                      final directory =
                          await getApplicationDocumentsDirectory();
                      final filePath =
                          '${directory.path}/foto_$_currentPage.jpg';
                      final xFile =
                          XFile.fromData(image.bytes, mimeType: 'image/jpeg');
                      await xFile.saveTo(filePath);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Image downloaded to $filePath'),
                        ),
                      );
                    }
                  },
                  error: (err, _) {},
                  loading: () {},
                );
              }
            },
            icon: const Icon(Icons.download),
          ),
        ],
      ),
      body: GestureDetector(
        child: PageView.builder(
          controller: _pageController,
          onPageChanged: (index) {
            setState(() {
              _currentPage = index;
              _preloadImages(index);
            });
          },
          itemBuilder: (context, index) {
            final path = widget.paths[index];
            final imageVal = ref.watch(galleryImageProvider(path.fullPath));

            return imageVal.when(
              data: (image) => Image.memory(image.bytes),
              error: (err, _) => Center(child: Text('Error: $err')),
              loading: () => const Center(child: CircularProgressIndicator()),
            );
          },
          itemCount: widget.paths.length,
        ),
        onHorizontalDragUpdate: (details) {
          if (details.primaryDelta! > 0) {
            // Swiping in right direction.
            if (_currentPage > 0) {
              _pageController.previousPage(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              );
            }
          } else if (details.primaryDelta! < 0) {
            // Swiping in left direction.
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
