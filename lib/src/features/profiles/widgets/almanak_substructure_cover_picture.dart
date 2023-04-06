import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ksrvnjord_main_app/assets/images.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/api/bestuur_picture_provider.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/api/substructure_picture_provider.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/zoomable_image.dart';
import 'package:tuple/tuple.dart';

/// A widget that shows the cover picture of a substructure.
/// Either [commissieAndYear] or [substructure] or [bestuurYear] must be set.
class AlmanakSubstructureCoverPicture extends ConsumerWidget {
  const AlmanakSubstructureCoverPicture({
    super.key,
    required this.imageAspectRatio,
    this.commissieAndYear,
    this.substructure,
    this.bestuurYear,
  });

  final double imageAspectRatio;
  final Tuple2<String, int>? commissieAndYear;
  final String? substructure;
  final int? bestuurYear;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    AsyncValue<ImageProvider<Object>> picture;
    if (commissieAndYear != null) {
      picture = ref.watch(commissiePictureProvider(commissieAndYear!));
    } else if (substructure != null) {
      picture = ref.watch(substructurePictureProvider(substructure!));
    } else if (bestuurYear != null) {
      picture = ref.watch(bestuurPictureProvider(bestuurYear!));
    } else {
      throw Exception('Either commissieAndYear or substructure must be set');
    }

    final double width = MediaQuery.of(context).size.width;
    final double height = width * imageAspectRatio;

    return ZoomableImage(
      imageProvider: picture.when(
        data: (data) => data,
        error: (err, stk) =>
            Image.asset(Images.placeholderProfilePicture).image,
        loading: () => Image.asset(Images.placeholderProfilePicture).image,
      ),
      image: picture.when(
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
