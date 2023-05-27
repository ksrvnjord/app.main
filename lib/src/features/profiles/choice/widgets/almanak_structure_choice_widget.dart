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

    final double imageHeight = ((screenSize.height / 7) / 8).ceil() * 8;

    return InkWell(
      child: [
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
        Text(
          title,
          style: Theme.of(context).textTheme.titleLarge,
        ).alignment(Alignment.center),
      ].toColumn().card(
            color: Theme.of(context).colorScheme.primaryContainer,
            elevation: 0,
          ),
      onTap: () => Routemaster.of(context).push(pushRoute),
    );
  }
}
