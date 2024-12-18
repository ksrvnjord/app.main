import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ksrvnjord_main_app/src/features/announcements/api/announcement_provider.dart';
import 'package:ksrvnjord_main_app/src/features/dashboard/widgets/widget_header.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/api/user_provider.dart';

class AnnouncementHeaderWidget extends ConsumerWidget {
  const AnnouncementHeaderWidget({super.key});

  Future<void> _pickImage(
      BuildContext context, WidgetRef ref, String author) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      // Handle the selected image
      final announcementNotifier = ref.watch(announcementProvider.notifier);
      announcementNotifier.createAnnouncement(author, image);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(currentUserProvider);

    return currentUser.when(
      data: (user) {
        final isAdmin = user.isAdmin; // Adjust based on your user model

        return WidgetHeader(
          title: "Aankondigingen",
          titleIcon: Icons.campaign,
          onTapName: isAdmin ? "Aankondiging toevoegen" : null,
          onTap: isAdmin
              ? () {
                  _pickImage(context, ref, user.identifier.toString());
                }
              : null,
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) => Text("Error: $err"),
    );
  }
}
