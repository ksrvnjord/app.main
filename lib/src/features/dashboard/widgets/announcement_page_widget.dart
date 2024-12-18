import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ksrvnjord_main_app/src/features/announcements/api/announcement_provider.dart';
import 'package:ksrvnjord_main_app/src/features/announcements/model/announcement.dart';

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
            child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: imageWidth,
                ),
                child: Image.memory(
                  snapshot.data!,
                  fit: BoxFit
                      .contain, // Ensure the image is scaled to fit within the constraints
                )),
          );
        } else {
          return const Icon(Icons.image_not_supported);
        }
      },
    );
  }
}
