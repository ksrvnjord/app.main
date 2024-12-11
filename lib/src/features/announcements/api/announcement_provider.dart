import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ksrvnjord_main_app/src/features/announcements/model/announcement.dart';

class AnnouncementNotifier extends Notifier<List<Announcement>> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  @override
  List<Announcement> build() {
    fetchRecentAnnouncements();
    return [];
  }

  /// Fetch announcements from the last 5 days
  Future<void> fetchRecentAnnouncements() async {
    final fiveDaysAgo =
        Timestamp.now().toDate().subtract(const Duration(days: 5));

    try {
      final querySnapshot = await _firestore
          .collection('announcements_v2')
          .where('created_at',
              isGreaterThanOrEqualTo: Timestamp.fromDate(fiveDaysAgo))
          .orderBy('created_at', descending: true)
          .get();

      state = querySnapshot.docs.map((doc) {
        final data = doc.data();
        return Announcement.fromMap(data);
      }).toList();
    } catch (e) {
      state = [];
      debugPrint('Error fetching announcements: $e');
    }
  }

  /// Create a new announcement (without a link)
  Future<void> createAnnouncement(String author) async {
    try {
      final collection = _firestore.collection('announcements_v2');
      final newAnnouncement = Announcement(
        id: collection.doc().id, // Generate a new ID
        author: author,
        createdAt: Timestamp.now(),
        link: null,
      );

      await collection.doc(newAnnouncement.id).set(newAnnouncement.toMap());
      state = [newAnnouncement, ...state];
    } catch (e) {
      debugPrint('Error creating announcement: $e');
    }
  }

  /// Update an announcement to add a link
  Future<void> updateAnnouncementLink(String id, String link) async {
    try {
      final index = state.indexWhere((a) => a.id == id);
      if (index != -1) {
        final updatedAnnouncement = state[index].copyWith(link: link);
        await _firestore
            .collection('announcements_v2')
            .doc(id)
            .update(updatedAnnouncement.toMap());
        state = [
          for (final announcement in state)
            if (announcement.id == id) updatedAnnouncement else announcement,
        ];
      }
    } catch (e) {
      debugPrint('Error updating announcement: $e');
    }
  }

  /// Delete an announcement and its associated photo
  Future<void> deleteAnnouncement(String id) async {
    try {
      await _firestore.collection('announcements_v2').doc(id).delete();
      await _storage.ref('announcements_v2/$id.png').delete();
      state = state.where((a) => a.id != id).toList();
    } catch (e) {
      debugPrint('Error deleting announcement: $e');
    }
  }
}

final announcementProvider =
    NotifierProvider<AnnouncementNotifier, List<Announcement>>(
        () => AnnouncementNotifier());
