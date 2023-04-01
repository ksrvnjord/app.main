import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ksrvnjord_main_app/assets/images.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/api/njord_year.dart';
import 'package:routemaster/routemaster.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:tuple/tuple.dart';

import '../api/substructure_picture_provider.dart';

class CommissieChoiceListTile extends ConsumerStatefulWidget {
  const CommissieChoiceListTile({
    Key? key,
    required this.commissie,
    required this.pushRoute,
    required this.queryParameterName,
  }) : super(key: key);
  final String commissie;
  final String queryParameterName;
  final String pushRoute;

  @override
  CommissieChoiceListTileState createState() => CommissieChoiceListTileState();
}

class CommissieChoiceListTileState
    extends ConsumerState<CommissieChoiceListTile>
    with AutomaticKeepAliveClientMixin {
  static const imageWidth = 80.0;
  static const imageHeight = 72.0;
  static const imageRightPadding = 8.0;
  static const titleFontSize = 16.0;
  static const iconHorizontalPadding = 16.0;

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final commissiePicture = ref.watch(
      commissiePictureProvider(Tuple2(widget.commissie, getNjordYear())),
    );

    return InkWell(
      onTap: () =>
          Routemaster.of(context).push(widget.pushRoute, queryParameters: {
        widget.queryParameterName: widget.commissie,
      }),
      child: [
        [
          Image(
            image: commissiePicture.when(
              data: (data) => data,
              error: (err, stk) =>
                  Image.asset(Images.placeholderProfilePicture).image,
              loading: () =>
                  Image.asset(Images.placeholderProfilePicture).image,
            ),
            width: imageWidth,
            height: imageHeight,
            fit: BoxFit.cover,
          ).padding(right: imageRightPadding),
          Text(widget.commissie).fontSize(titleFontSize),
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
