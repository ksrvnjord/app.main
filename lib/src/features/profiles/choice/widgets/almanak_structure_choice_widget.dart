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

    final double imageHeight = ((screenSize.height / 7) / 8).ceil() * 7.3;

    final colorScheme = Theme.of(context).colorScheme;

    const bottomTextPadding = 6.0;

    return InkWell(
      child: [
        Stack(
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(12)),
              child: Image(
                image: AssetImage(imagePath),
                width: double.infinity,
                height: imageHeight,
                fit: BoxFit.cover,
                isAntiAlias: true,
              ),
            ),
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(12)),
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.center,
                    colors: [
                      Colors.black.withOpacity(1),
                      Colors.transparent,
                    ],
                    stops: const [0.0, 0.8],
                  ),
                ),
              ),
            ),
          ],
        ),
        Text(
          title,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
              // Color: colorScheme.onPrimaryContainer,.
              ),
        ).padding(bottom: bottomTextPadding),
      ].toStack(alignment: Alignment.bottomCenter).card(
            color: colorScheme.primaryContainer,
          ),
      onTap: () => context.goNamed(pushRoute),
    );
  }
}
