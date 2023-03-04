import 'package:flutter/material.dart';
import 'package:routemaster/routemaster.dart';
import 'package:styled_widget/styled_widget.dart';

class AlmanakStructureChoiceWidget extends StatelessWidget {
  const AlmanakStructureChoiceWidget({
    super.key,
    required this.pushRoute,
    required this.title,
    required this.imagePath,
  });

  final String title;
  final String pushRoute;
  final String imagePath;

  @override
  Widget build(BuildContext context) {
    const double cardTitleFontSize = 24;
    const double imageHeight = 160;

    return InkWell(
      onTap: () => Routemaster.of(context).push(pushRoute),
      child: [
        // load image from assets
        Image(
          image: AssetImage(imagePath),
          width: double.infinity,
          height: imageHeight,
          fit: BoxFit.cover,
        ),
        Text(title).fontSize(cardTitleFontSize).alignment(Alignment.center),
      ].toColumn().card(),
    );
  }
}
