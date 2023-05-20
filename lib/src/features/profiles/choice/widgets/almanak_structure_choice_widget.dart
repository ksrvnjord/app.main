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
    final screenSize = MediaQuery.of(context).size;
    final screenWidth = screenSize.width;

    final double cardTitleFontSize = screenWidth < 480
        ? 20
        : screenWidth < 768
            ? 24
            : 28;
    final double imageHeight = ((screenSize.height / 7) / 8).ceil() * 8;

    return InkWell(
        child: [
          ClipRRect(
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16), topRight: Radius.circular(16)),
              child: Image(
                  image: AssetImage(imagePath),
                  width: double.infinity,
                  height: imageHeight,
                  fit: BoxFit.cover,
                  isAntiAlias: true)),
          Text(title)
              .fontSize(cardTitleFontSize)
              .textColor(Colors.white)
              .alignment(Alignment.center)
        ].toColumn().card(
            color: Colors.lightBlue,
            elevation: 0,
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(16)))),
        onTap: () => Routemaster.of(context).push(pushRoute));
  }
}
