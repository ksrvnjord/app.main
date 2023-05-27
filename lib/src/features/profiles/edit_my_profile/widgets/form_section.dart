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
    const double fieldVPadding = 16;
    const double cardInnerPadding = 16;

    return [
      Text(
        title,
        style: Theme.of(context).textTheme.titleLarge,
      ),
      children
          .toColumn(
            separator: const SizedBox(height: fieldVPadding),
          )
          .padding(all: cardInnerPadding)
          .card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              side: BorderSide(
                color: Theme.of(context).colorScheme.outline,
              ),
              borderRadius: const BorderRadius.all(Radius.circular(12)),
            ),
          ),
    ].toColumn(
      crossAxisAlignment: CrossAxisAlignment.start,
    );
  }
}
