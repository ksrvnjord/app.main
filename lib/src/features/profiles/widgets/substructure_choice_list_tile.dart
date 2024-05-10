import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ksrvnjord_main_app/assets/images.dart';
import 'package:styled_widget/styled_widget.dart';

class SubstructureChoiceListTile extends ConsumerWidget {
  static const imageWidth = 80.0;
  static const imageHeight = 72.0;
  static const imageRightPadding = 16.0;
  static const iconHorizontalPadding = 16.0;

  const SubstructureChoiceListTile({
    super.key,
    required this.name,
    required this.imageProvider, // The imageProvider for the choice.
    required this.onTap,
  });
  final String name;

  final void Function() onTap;
  final AsyncValue<ImageProvider<Object>> imageProvider;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const int maxLines = 2;

    // ignore: arguments-ordering
    return InkWell(
      onTap: onTap,
      child: [
        FadeInImage(
          placeholder: Image.asset(Images.placeholderProfilePicture).image,
          image: imageProvider.when(
            data: (data) => data,
            error: (err, stk) =>
                Image.asset(Images.placeholderProfilePicture).image,
            loading: () => Image.asset(Images.placeholderProfilePicture).image,
          ),
          fadeOutDuration: const Duration(milliseconds: 600),
          fadeInDuration: const Duration(milliseconds: 800),
          width: imageWidth,
          height: imageHeight,
          fit: BoxFit.cover,
          // ignore: no-equal-arguments
          placeholderFit: BoxFit.cover,
        ).padding(right: imageRightPadding),
        Text(
          name,
          style: Theme.of(context).textTheme.titleMedium,
          maxLines: maxLines,
        ).expanded(),
        Icon(
          Icons.arrow_forward_ios,
          color: Theme.of(context).colorScheme.primary,
        ).padding(horizontal: iconHorizontalPadding),
      ].toRow(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
      ),
    );
  }
}
