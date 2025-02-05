import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ksrvnjord_main_app/src/features/announcements/api/announcement_provider.dart';


Future<void> pickImage(
      BuildContext context, WidgetRef ref, String author) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      // Handle the selected image
      final announcementNotifier = ref.watch(announcementProvider.notifier);
      announcementNotifier.createAnnouncement(author, image);
    }
  }