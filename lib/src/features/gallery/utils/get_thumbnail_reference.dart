import 'package:firebase_storage/firebase_storage.dart';

Reference getThumbnailReference(Reference ref) {
  if (ref.parent == null) {
    throw Exception(
      'Thumbnail for the root reference was requested.',
    );
  }

  // Firebase Extensions makes thumbnails in the Thumbnails folder
  List<String> pathComponents = ref.fullPath.split('/');
  pathComponents.insert(
    //Insert path to thumbnails folder
    // Example: /galerij/2022 duinloop/image.jpg -> /galerij/2022 duinloop/thumbnails/image.jpg
    pathComponents.length - 1,
    'thumbnails',
  );

  // We want to serve the 200x200 thumbnail, so we replace the first dot with _200x200.
  // find the last dot position
  //// Example: image.jpg -> image_200x200.jpg
  pathComponents.last = pathComponents.last.replaceFirst(
    '.',
    '_200x200.',
    pathComponents.last.lastIndexOf('.'),
  );

  String fullPath = pathComponents.join('/');

  return ref.root.child(fullPath);
}
