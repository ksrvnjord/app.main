import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
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

    final colorScheme = Theme.of(context).colorScheme;

    return InkWell(
      child: [
        ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(12),
            // ignore: no-equal-arguments
            topRight: Radius.circular(12),
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
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: colorScheme.onPrimaryContainer,
              ),
        ).alignment(Alignment.center),
      ].toColumn().card(
            color: colorScheme.primaryContainer,
          ),
      onTap: () => context.pushNamed(pushRoute),
    );
  }
}
