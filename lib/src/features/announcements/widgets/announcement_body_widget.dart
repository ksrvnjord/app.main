import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:url_launcher/url_launcher_string.dart';

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
    return ListView(
      children: [
        // show title of announcement emphasized
        Text(
          title,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ).padding(bottom: 8),
        MarkdownBody(
          data: text,
          onTapLink: (text, url, title) {
            // Check if an URL is actually given
            if (url?.isNotEmpty ?? false) {
              // Launch the URL
              launchUrlString(url!);
            }
          },
        ),
      ],
    );
  }
}
