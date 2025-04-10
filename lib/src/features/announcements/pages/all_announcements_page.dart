import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ksrvnjord_main_app/src/features/announcements/api/all_announcement_image_provider.dart';
import 'package:ksrvnjord_main_app/src/features/announcements/widgets/announcement_folder_list.dart';
import 'package:ksrvnjord_main_app/src/features/gallery/utils/gallery_view_provider.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/error_text_widget.dart';

class AllAnnouncementsPage extends ConsumerWidget {
  const AllAnnouncementsPage({
    super.key,
    required this.path,
  });

  final String path;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allAnnouncementImages = ref.watch(announcementImageProvider);

    final gridOrList = ref.watch(gridOrListViewProvider);

    return Scaffold(
        appBar: AppBar(
          leading: path == '/'
              ? IconButton(
                  onPressed: () => context.pop(),
                  icon: const Icon(Icons.arrow_back),
                )
              : null,
          title: Text("Alle aankondigingen"),
          actions: [
            IconButton(
              onPressed: () =>
                  ref.read(gridOrListViewProvider.notifier).state = !gridOrList,
              icon: Icon(gridOrList ? Icons.grid_view_rounded : Icons.list),
            ),
          ],
        ),
        body: allAnnouncementImages.when(
            data: (items) => AnnouncementFolderList(items: items),
            error: (err, trace) => ErrorTextWidget(
                  errorMessage: err.toString(),
                ),
            loading: () => const CircularProgressIndicator.adaptive()));
  }
}
