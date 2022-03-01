import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class DevelopmentFeature extends StatelessWidget {
  const DevelopmentFeature({Key? key, this.child}) : super(key: key);

  final Widget? child;
  @override
  Widget build(BuildContext context) {
    return !kReleaseMode ? child ?? Container() : Container();
  }
}
