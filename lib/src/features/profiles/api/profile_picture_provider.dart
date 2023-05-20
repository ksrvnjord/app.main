import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ksrvnjord_main_app/src/features/shared/model/cached_profile_picture.dart';

// Gets profile picture for a user, by looking first in cache.
// Returns a placeholder image if the user has no profile picture.
// ignore: prefer-static-class
final profilePictureProvider =
    FutureProvider.autoDispose.family<ImageProvider<Object>, String>(
  (ref, identifier) => CachedProfilePicture.get(identifier),
);

// ignore: prefer-static-class
final profilePictureThumbnailProvider =
    FutureProvider.autoDispose.family<ImageProvider<Object>, String>(
  (ref, identifier) => CachedProfilePicture.getThumbnail(identifier),
);
