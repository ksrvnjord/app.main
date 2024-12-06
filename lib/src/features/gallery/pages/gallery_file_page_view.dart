// ignore_for_file: prefer-extracting-callbacks, prefer-extracting-function-callbacks

import 'dart:async';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ksrvnjord_main_app/src/features/gallery/api/gallery_image_provider.dart';
import 'package:share_plus/share_plus.dart';

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
                            name: "foto_$_currentPage.jpg",
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
        ],
      ),
      body: GestureDetector(
        child: PageView.builder(
          controller: _pageController,
          onPageChanged: (index) {
            setState(() {
              _currentPage = index;
            });
          },
          itemBuilder: (context, index) {
            final path = widget.paths[index];
            final imageVal = ref.watch(galleryImageProvider(path.fullPath));

            return imageVal.when(
              data: (image) => Image.memory(image.bytes),
              error: (err, _) => Center(child: Text('Error: $err')),
              loading: () =>
                  Center(child: CircularProgressIndicator.adaptive()),
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
