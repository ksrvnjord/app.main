import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ksrvnjord_main_app/assets/images.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/api/njord_year.dart';
import 'package:routemaster/routemaster.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:tuple/tuple.dart';

import '../api/substructure_picture_provider.dart';

class SubstructureChoiceListTile extends ConsumerWidget {
  static const imageWidth = 80.0;
  static const imageHeight = 72.0;
  static const imageRightPadding = 16.0;
  static const titleFontSize = 16.0;
  static const iconHorizontalPadding = 16.0;

  const SubstructureChoiceListTile({
    Key? key,
    required this.name,
    required this.imageProvider, // the imageProvider for the choice
  }) : super(key: key);
  final String name;

  final AsyncValue<ImageProvider<Object>> imageProvider;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return InkWell(
      onTap: () => Routemaster.of(context).push(name),
      child: [
        [
          FadeInImage(
            placeholder: Image.asset(Images.placeholderProfilePicture).image,
            image: imageProvider.when(
              data: (data) => data,
              error: (err, stk) =>
                  Image.asset(Images.placeholderProfilePicture).image,
              loading: () =>
                  Image.asset(Images.placeholderProfilePicture).image,
            ),
            width: imageWidth,
            height: imageHeight,
            fadeInDuration: const Duration(milliseconds: 800),
            fadeOutDuration: const Duration(milliseconds: 600),
            fit: BoxFit.cover,
            // ignore: no-equal-arguments
            placeholderFit: BoxFit.cover,
          ).padding(right: imageRightPadding),
          Text(name).fontSize(titleFontSize),
        ].toRow().alignment(Alignment.centerLeft),
        const Icon(
          Icons.arrow_forward_ios,
          color: Colors.lightBlue,
        ).padding(horizontal: iconHorizontalPadding),
      ].toRow(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
      ),
    );
  }
}
