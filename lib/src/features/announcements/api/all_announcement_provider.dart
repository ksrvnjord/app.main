import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ksrvnjord_main_app/src/features/announcements/model/announcement.dart';

/// The Notifier that fetches all announcements from Firestore.
/// It closely resembles the [AnnouncementNotifier] but fetches all announcements.
/// Modifications should be made to the [AnnouncementNotifier] as well.

class AllAnnouncementNotifier extends Notifier<List<Announcement>> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final Map<String, Uint8List> _imageCache = {};

  @override
  List<Announcement> build() {
    fetchAllAnnouncements();
    return [];
  }

  /// Fetch all announcements
  void fetchAllAnnouncements() {
    _firestore
        .collection('announcements_v2')
        .orderBy('created_at', descending: true)
        .snapshots()
        .listen((querySnapshot) {
      state = querySnapshot.docs.map((doc) {
        final data = doc.data();
        return Announcement.fromMap(data);
      }).toList();
    }, onError: (error) {
      debugPrint('Error fetching announcements: $error');
      state = [];
    });
  }

  Future<Uint8List?> getImage(String id) async {
    if (_imageCache.containsKey(id)) {
      return _imageCache[id];
    }

    try {
      final storageRef = _storage.ref('announcements_v2/$id.png');
      final data = await storageRef.getData();
      if (data != null) {
        _imageCache[id] = data;
      }
      return data;
    } catch (e) {
      debugPrint('Error getting image: $e');
      return null;
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

final allAnnouncementProvider =
    NotifierProvider<AllAnnouncementNotifier, List<Announcement>>(
        () => AllAnnouncementNotifier());
