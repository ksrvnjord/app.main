import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:url_launcher/url_launcher.dart';

class AnnouncementBodyWidget extends StatelessWidget {
  const AnnouncementBodyWidget({
    super.key,
    required this.title,
    required this.text,
  });

  final String title;
  final String text;

  @override
  Widget build(BuildContext context) {
    const double spacingBetweenTitleAndText = 8;

    return ListView(
      padding: const EdgeInsets.all(8),
      children: [
        // Show title of announcement emphasized.
        Text(
          title,
          style: Theme.of(context).textTheme.titleLarge,
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
    // Check if an URL is actually given.
    if (url.isNotEmpty) {
      // Convert url to URI.
      final uri = Uri.parse(url);
      // Launch url in separate browser.
      // ignore: avoid-ignoring-return-values
      launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}
