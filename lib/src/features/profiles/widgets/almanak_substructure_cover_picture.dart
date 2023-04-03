import 'package:flutter/material.dart';
import 'package:ksrvnjord_main_app/assets/images.dart';

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
    return FadeInImage(
      placeholder: Image.asset(Images.placeholderProfilePicture).image,
      image: imageProvider,
      fit: BoxFit.cover,
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.width * imageAspectRatio,
    );
  }
}
