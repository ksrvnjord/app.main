import 'package:easy_image_viewer/easy_image_viewer.dart';
import 'package:flutter/material.dart';

class ZoomableImage extends StatelessWidget {
  const ZoomableImage({
    Key? key,
    required this.imageProvider,
    required this.image,
  }) : super(key: key);

  final ImageProvider imageProvider;
  final Image image;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => showImageViewer(
        context,
        imageProvider,
        swipeDismissible: true,
        doubleTapZoomable: true,
      ),
      child: image,
    );
  }
}
