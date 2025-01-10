import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ksrvnjord_main_app/src/features/announcements/api/announcement_provider.dart';
import 'package:ksrvnjord_main_app/src/features/announcements/model/announcement.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/api/user_provider.dart';

class AnnouncementPageWidget extends ConsumerWidget {
  const AnnouncementPageWidget({
    super.key,
    required this.announcement,
  });

  final Announcement announcement;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final announcementNotifier = ref.read(announcementProvider.notifier);
    final imageFuture = announcementNotifier.getImage(announcement.id);
    final currentUserAsyncValue = ref.watch(currentUserProvider);

    return currentUserAsyncValue.when(
      data: (currentUser) {
        return FutureBuilder<Uint8List?>(
          future: imageFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return const Icon(Icons.image_not_supported);
            } else if (snapshot.hasData) {
              final screenWidth = MediaQuery.of(context).size.width;
              final padding = 16.0;
              final imageWidth = screenWidth - (2 * padding);

              return Padding(
                  padding: EdgeInsets.all(padding), // Add padding on all sides
                  child: SizedBox(
                    height: 600,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        FutureBuilder<Size>(
                          future: _getImageSize(snapshot.data!),
                          builder: (context, sizeSnapshot) {
                            if (sizeSnapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                  child: CircularProgressIndicator());
                            } else if (sizeSnapshot.hasError) {
                              return const Icon(Icons.image_not_supported);
                            } else if (sizeSnapshot.hasData) {
                              final aspectRatio = sizeSnapshot.data!.width /
                                  sizeSnapshot.data!.height;
                              return Flexible(
                                  fit: FlexFit.loose,
                                  child: AspectRatio(
                                    aspectRatio: aspectRatio,
                                    child: Image.memory(
                                      snapshot.data!,
                                      fit: BoxFit
                                          .cover, // Ensure the image takes the full available width
                                      width: imageWidth,
                                    ),
                                  ));
                            } else {
                              return const Icon(Icons.image_not_supported);
                            }
                          },
                        ),
                      ],
                    ),
                  ));
            } else {
              return const Icon(Icons.image_not_supported);
            }
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stackTrace) => const Icon(Icons.error),
    );
  }

  Future<Size> _getImageSize(Uint8List imageData) async {
    final Completer<Size> completer = Completer();
    final Image image = Image.memory(imageData);
    image.image.resolve(const ImageConfiguration()).addListener(
      ImageStreamListener((ImageInfo info, bool _) {
        completer.complete(
            Size(info.image.width.toDouble(), info.image.height.toDouble()));
      }),
    );
    return completer.future;
  }
}
