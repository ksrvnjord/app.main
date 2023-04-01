import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/api/njord_year.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/shimmer_widget.dart';
import 'package:routemaster/routemaster.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:tuple/tuple.dart';

import '../api/substructure_picture_provider.dart';

class CommissieChoiceListTile extends ConsumerWidget {
  const CommissieChoiceListTile({
    Key? key,
    required this.commissie,
    required this.pushRoute,
    required this.queryParameterName,
  }) : super(key: key);

  final String commissie;
  final String queryParameterName;
  final String pushRoute;

  static const imageWidth = 80.0;
  static const imageHeight = 72.0;
  static const imageRightPadding = 8.0;
  static const titleFontSize = 16.0;
  static const iconHorizontalPadding = 16.0;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final commissiePicture =
        ref.watch(commissiePictureProvider(Tuple2(commissie, getNjordYear())));

    return InkWell(
      onTap: () => Routemaster.of(context).push(pushRoute, queryParameters: {
        queryParameterName: commissie,
      }),
      child: [
        [
          commissiePicture
              .when(
                data: (image) => Image(
                  image: image,
                  width: imageWidth,
                  height: imageHeight,
                  fit: BoxFit.cover,
                ),
                error: (err, stk) => const SizedBox.shrink(),
                loading: () => const ShimmerWidget(child: CircleAvatar()),
              )
              .padding(right: imageRightPadding),
          Text(commissie).fontSize(titleFontSize),
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
