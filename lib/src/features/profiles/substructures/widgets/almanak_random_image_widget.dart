import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ksrvnjord_main_app/assets/images.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/api/substructure_picture_provider.dart';

class RandomCommissieImage extends ConsumerWidget {
  const RandomCommissieImage({
    super.key,
    required this.year,
  });

  final String year;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final commissiePictureVal = ref.watch(
      randomCommissiePictureProvider(int.parse(year)),
    );

    return commissiePictureVal.when(
      data: (data) => FadeInImage(
        placeholder: Image.asset(Images.placeHolderCommissie).image,
        image: data,
        fadeOutDuration: const Duration(milliseconds: 600),
        fadeInDuration: const Duration(milliseconds: 800),
        width: double.infinity,
        height: double.infinity,
        fit: BoxFit.cover,
      ),
      error: (err, stk) => Image.asset(
        Images.placeHolderCommissie,
        width: double.infinity,
        height: double.infinity,
        fit: BoxFit.cover,
        isAntiAlias: true,
      ),
      loading: () => Image.asset(
        Images.placeHolderCommissie,
        width: double.infinity,
        height: double.infinity,
        fit: BoxFit.cover,
        isAntiAlias: true,
      ),
    );
  }
}

class RandomVerticalImage extends ConsumerWidget {
  const RandomVerticalImage({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final verticalPictureVal = ref.watch(
      randomVerticalPictureProvider,
    );

    return verticalPictureVal.when(
      data: (data) => FadeInImage(
        placeholder: Image.asset(Images.placeHolderVerticaal).image,
        image: data,
        fadeOutDuration: const Duration(milliseconds: 600),
        fadeInDuration: const Duration(milliseconds: 800),
        width: double.infinity,
        height: double.infinity,
        fit: BoxFit.cover,
      ),
      error: (err, stk) => Image.asset(
        Images.placeHolderVerticaal,
        width: double.infinity,
        height: double.infinity,
        fit: BoxFit.cover,
        isAntiAlias: true,
      ),
      loading: () => Image.asset(
        Images.placeHolderVerticaal,
        width: double.infinity,
        height: double.infinity,
        fit: BoxFit.cover,
        isAntiAlias: true,
      ),
    );
  }
}
