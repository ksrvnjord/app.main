import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:url_launcher/url_launcher.dart';

class AnnouncementBodyWidget extends StatelessWidget {
  const AnnouncementBodyWidget({
    Key? key,
    required this.title,
    required this.text,
  }) : super(key: key);

  final String title;
  final String text;

  @override
  Widget build(BuildContext context) {
    const double spacingBetweenTitleAndText = 8;

    return ListView(
      children: [
        // show title of announcement emphasized
        Text(
          title,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ).padding(bottom: spacingBetweenTitleAndText),
        MarkdownBody(
          data: text,
          onTapLink: launchUrlIfPossible,
        ),
      ],
    );
  }

  void launchUrlIfPossible(_, String? url, __) {
    if (url == null) {
      return;
    }
    // Check if an URL is actually given
    if (url.isNotEmpty) {
      // convert url to URI
      final uri = Uri.parse(url);
      // launch url in separate browser
      // ignore: avoid-ignoring-return-values
      launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}
