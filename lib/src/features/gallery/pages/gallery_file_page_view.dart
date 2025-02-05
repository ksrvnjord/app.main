// ignore_for_file: prefer-extracting-callbacks, prefer-extracting-function-callbacks

import 'dart:async';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ksrvnjord_main_app/src/features/gallery/api/gallery_image_provider.dart';
import 'package:share_plus/share_plus.dart';

/// A Page that displays a single image from the gallery.

class GalleryFilePageView extends ConsumerStatefulWidget {
  const GalleryFilePageView({
    super.key,
    required this.initialIndex,
    required this.paths,
  });

  final int initialIndex;
  final List<Reference> paths;

  @override
  GalleryFilePageViewState createState() => GalleryFilePageViewState();
}

class GalleryFilePageViewState extends ConsumerState<GalleryFilePageView> {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Gallery"),
        actions: [
          IconButton(
            onPressed: () {
              final path = widget.paths.elementAtOrNull(_currentPage);
              if (path != null) {
                final imageVal = ref.watch(galleryImageProvider(path.fullPath));

                imageVal.when(
                  data: (image) {
                    // Handle sharing functionality here.
                    Share.shareXFiles(
                      [
                        XFile.fromData(
                          image.bytes,
                          mimeType: "image/jpeg",
                          name: "$path.jpg",
                        ),
                      ],
                      subject: "Foto",
                    ).ignore();
                  },
                  error: (err, _) {},
                  loading: () {},
                );
              }
            },
            icon: const Icon(Icons.share),
          ),
        ],
      ),
      body: GestureDetector(
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
                error: (err, _) => Center(child: Text('Error: $err')),
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
