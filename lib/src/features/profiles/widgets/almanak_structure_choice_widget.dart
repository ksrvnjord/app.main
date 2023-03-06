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
    const double imageHeight = 128;

    return InkWell(
      onTap: () => Routemaster.of(context).push(pushRoute),
      child: [
        // load image from assets
        ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(16),
            // ignore: no-equal-arguments
            topRight: Radius.circular(16),
          ),
          child: Image(
            image: AssetImage(imagePath),
            width: double.infinity,
            height: imageHeight,
            fit: BoxFit.cover,
            isAntiAlias: true,
          ),
        ),
        Text(title)
            .fontSize(cardTitleFontSize)
            .textColor(Colors.white)
            .alignment(Alignment.center),
      ].toColumn().card(
            color: Colors.lightBlue,
            elevation: 0,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(16)),
            ),
          ),
    );
  }
}