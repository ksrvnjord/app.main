import 'package:flutter/material.dart';
import 'package:styled_widget/styled_widget.dart';

class FormSection extends StatelessWidget {
  const FormSection({
    Key? key,
    required this.title,
    required this.children,
    this.padding = const EdgeInsets.symmetric(vertical: 8.0),
  }) : super(key: key);

  final String title;
  final List<Widget> children;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    const double headerFontSize = 20;
    const double fieldVPadding = 8;
    const double fieldHPadding = 8;

    return [
      Text(
        title,
      ).fontSize(headerFontSize),
      children
          .toColumn(
            separator: const SizedBox(height: fieldVPadding),
          )
          .padding(horizontal: fieldHPadding),
    ].toColumn(
      crossAxisAlignment: CrossAxisAlignment.start,
    );
  }
}
