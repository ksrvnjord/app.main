import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ksrvnjord_main_app/src/features/shared/model/cached_profile_picture.dart';

final storage = FirebaseStorage.instance;
final auth = FirebaseAuth.instance;

// Gets profile picture for a user, by looking first in cache.
// Returns a placeholder image if the user has no profile picture.
final profilePictureProvider =
    FutureProvider.autoDispose.family<ImageProvider<Object>, String>(
  (ref, identifier) => CachedProfilePicture.get(identifier),
);

final profilePictureThumbnailProvider =
    FutureProvider.autoDispose.family<ImageProvider<Object>, String>(
  (ref, identifier) => CachedProfilePicture.getThumbnail(identifier),
);
