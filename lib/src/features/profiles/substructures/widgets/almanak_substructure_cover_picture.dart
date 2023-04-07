import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ksrvnjord_main_app/assets/images.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/zoomable_image.dart';

/// A widget that shows the cover image of a substructure.
class AlmanakSubstructureCoverPicture extends ConsumerWidget {
  const AlmanakSubstructureCoverPicture({
    super.key,
    // ignore: no-magic-number
    this.imageAspectRatio = 9 / 16,
    required this.imageProvider,
  });

  final double imageAspectRatio;
  final AsyncValue<ImageProvider<Object>> imageProvider;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final double width = MediaQuery.of(context).size.width;
    final double height = width * imageAspectRatio;

    return ZoomableImage(
      imageProvider: imageProvider.when(
        data: (data) => data,
        error: (err, stk) =>
            Image.asset(Images.placeholderProfilePicture).image,
        loading: () => Image.asset(Images.placeholderProfilePicture).image,
      ),
      image: imageProvider.when(
        data: (data) => FadeInImage(
          placeholder: Image.asset(Images.placeholderProfilePicture).image,
          image: data,
          fit: BoxFit.cover,
          width: width,
          height: height,
        ),
        error: (err, stk) => Image.asset(Images.placeholderProfilePicture),
        // loading show shimmer widget here
        loading: () => Image.asset(
          Images.placeholderProfilePicture,
          width: width,
          height: height,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
