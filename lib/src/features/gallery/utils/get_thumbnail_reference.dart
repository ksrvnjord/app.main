import 'package:firebase_storage/firebase_storage.dart';

const secondToLast = 1;

Reference getThumbnailReference(Reference ref) {
  if (ref.parent == null) {
    throw Exception(
      'Thumbnail for the root reference was requested.',
    );
  }

  // Move the file to the thumbnail folder
  List<String> pathComponents = ref.fullPath.split('/');
  pathComponents.insert(
    pathComponents.length - secondToLast,
    'thumbnails',
  );

  String fullPath = pathComponents.join('/');
  fullPath = fullPath.replaceAll('.', '_200x200.');

  return ref.root.child(fullPath);
}
