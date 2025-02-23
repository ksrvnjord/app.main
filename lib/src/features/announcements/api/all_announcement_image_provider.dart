import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ksrvnjord_main_app/src/features/announcements/api/all_announcement_provider.dart';

final storageProvider = Provider((ref) => FirebaseStorage.instance);

final announcementImageProvider = FutureProvider<List<Reference>>((ref) async {
  final storage = ref.read(storageProvider);

  final allAnnouncements = ref.watch(allAnnouncementProvider);

  // Extract the IDs from the documents
  final ids = allAnnouncements.map((e) => e.id).toList();

  // Fetch the references from Firebase Storage
  final references =
      ids.map((id) => storage.ref('announcements_v2/$id.png')).toList();

  return references;
});
