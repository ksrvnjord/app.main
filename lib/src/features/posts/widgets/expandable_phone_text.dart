import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';

class ExpandablePhoneText extends StatefulWidget {
  const ExpandablePhoneText({
    super.key,
    required this.text,
    this.style,
    this.maxLines = 12,
    this.expanded = false,
  });

  final String text;
  final TextStyle? style;
  final int maxLines;
  final bool expanded;

  @override
  State<ExpandablePhoneText> createState() => _ExpandablePhoneTextState();
}

class _ExpandablePhoneTextState extends State<ExpandablePhoneText> {
  late bool isExpanded;

  final RegExp phoneRegex = RegExp(
    r'(?:\+31[\s-]?6|06)[\s-]?\d{8}',
  );

  final RegExp urlRegex = RegExp(
    r'https?:\/\/[^\s]+',
  );

  @override
  void initState() {
    super.initState();
    isExpanded = widget.expanded;
  }

  List<InlineSpan> _buildTextSpans() {
    final List<InlineSpan> spans = [];

    final combinedRegex = RegExp(
      '${urlRegex.pattern}|${phoneRegex.pattern}',
    );

    final matches = combinedRegex.allMatches(widget.text);

    int lastIndex = 0;

    for (final match in matches) {
      if (match.start > lastIndex) {
        spans.add(
          TextSpan(
            text: widget.text.substring(
              lastIndex,
              match.start,
            ),
          ),
        );
      }

      final matchedText = match.group(0)!;

      if (urlRegex.hasMatch(matchedText)) {
        spans.add(
          TextSpan(
            text: matchedText,
            style: const TextStyle(
              color: Colors.blue,
              decoration: TextDecoration.underline,
            ),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                launchUrlString(matchedText);
              },
          ),
        );
      } else if (phoneRegex.hasMatch(matchedText)) {
        spans.add(
          TextSpan(
            text: matchedText,
            style: const TextStyle(
              color: Colors.blue,
              decoration: TextDecoration.underline,
            ),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                final cleanedPhoneNumber =
                    matchedText.replaceAll(' ', '').replaceAll('-', '');

                launchUrlString(
                  'tel:$cleanedPhoneNumber',
                );
              },
          ),
        );
      }

      lastIndex = match.end;
    }

    if (lastIndex < widget.text.length) {
      spans.add(
        TextSpan(
          text: widget.text.substring(lastIndex),
        ),
      );
    }

    return spans;
  }

  @override
  Widget build(BuildContext context) {
    final textStyle = widget.style ?? DefaultTextStyle.of(context).style;

    return LayoutBuilder(
      builder: (context, constraints) {
        final textPainter = TextPainter(
          text: TextSpan(
            style: textStyle,
            children: _buildTextSpans(),
          ),
          maxLines: widget.maxLines,
          textDirection: TextDirection.ltr,
        );

        textPainter.layout(
          maxWidth: constraints.maxWidth,
        );

        final isOverflowing = textPainter.didExceedMaxLines;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RichText(
              maxLines: isExpanded ? null : widget.maxLines,
              overflow:
                  isExpanded ? TextOverflow.visible : TextOverflow.ellipsis,
              text: TextSpan(
                style: textStyle,
                children: _buildTextSpans(),
              ),
            ),
            if (isOverflowing || isExpanded)
              GestureDetector(
                onTap: () {
                  setState(() {
                    isExpanded = !isExpanded;
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.only(top: 2),
                  child: Text(
                    isExpanded ? 'minder' : 'meer',
                    style: const TextStyle(
                      color: Colors.blueGrey,
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
