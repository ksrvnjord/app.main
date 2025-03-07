import 'package:easy_image_viewer/easy_image_viewer.dart';
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
      onTap: () => showImageViewer(
        context,
        imageProvider,
        swipeDismissible: true,
        doubleTapZoomable: true,
      ),
    );
  }
}
