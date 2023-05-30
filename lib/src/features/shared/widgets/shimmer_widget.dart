import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerWidget extends StatelessWidget {
  const ShimmerWidget({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    const double bgOpacity = 0.1;
    const double highlightOpacity = 0.4;

    return Shimmer.fromColors(
      // ignore: sort_child_properties_last
      child: child,
      baseColor: colorScheme.outline.withOpacity(bgOpacity),
      highlightColor: colorScheme.outline.withOpacity(highlightOpacity),
    );
  }
}
