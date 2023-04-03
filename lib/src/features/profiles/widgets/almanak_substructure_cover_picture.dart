import 'package:flutter/material.dart';

class AlmanakSubstructureCoverPicture extends StatelessWidget {
  const AlmanakSubstructureCoverPicture({
    super.key,
    required this.imageAspectRatio,
    required this.imageProvider,
  });

  final double imageAspectRatio;
  final ImageProvider imageProvider;

  @override
  Widget build(BuildContext context) {
    return Image(
      image: imageProvider,
      fit: BoxFit.cover,
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.width * imageAspectRatio,
    );
  }
}
