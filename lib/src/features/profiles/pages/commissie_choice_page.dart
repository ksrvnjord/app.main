import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ksrvnjord_main_app/assets/images.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/api/njord_year.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/api/substructure_picture_provider.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/shimmer_widget.dart';
import 'package:routemaster/routemaster.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:tuple/tuple.dart';

/// Page that shows a list of choices, and pushes a new page when a choice is chosen
class CommissieChoicePage extends ConsumerWidget {
  const CommissieChoicePage({
    Key? key,
    required this.title,
    required this.choices,
    required this.pushRoute,
    required this.queryParameterName,
  }) : super(key: key);

  final String title;
  final List<String> choices;
  final String pushRoute;
  final String queryParameterName;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: Colors.lightBlue,
        shadowColor: Colors.transparent,
        systemOverlayStyle:
            const SystemUiOverlayStyle(statusBarColor: Colors.lightBlue),
      ),
      body: ListView(
        children: choices
            .map(
              (choice) => [
                CommissieListTile(
                  commissie: choice,
                  pushRoute: pushRoute,
                  queryParameterName: queryParameterName,
                ),
                const Divider(
                  thickness: 0.5,
                  height: 0,
                ),
              ].toColumn(),
            )
            .toList(),
      ),
    );
  }
}

class CommissieListTile extends ConsumerWidget {
  const CommissieListTile({
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
