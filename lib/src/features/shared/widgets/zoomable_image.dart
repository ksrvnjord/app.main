import 'package:flutter/material.dart';

class ZoomableImage extends StatelessWidget {
  const ZoomableImage({
    super.key,
    required this.imageProvider,
    required this.image,
  });

  final ImageProvider imageProvider;
  final Widget image;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: image,
      onTap: () {
        showDialog(
          context: context,
          builder: (context) => Dialog(
            backgroundColor: Colors.black,
            child: ImageViewerDialog(imageProvider: imageProvider),
          ),
        );
      },
    );
  }
}

class ImageViewerDialog extends StatelessWidget {
  const ImageViewerDialog({
    super.key,
    required this.imageProvider,
  });

  final ImageProvider imageProvider;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pop(context),
      child: Center(
        child: InteractiveViewer(
          child: Image(image: imageProvider),
        ),
      ),
    );
  }
}
