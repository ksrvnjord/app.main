import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:url_launcher/url_launcher.dart';

class InstagramRowWidget extends StatelessWidget {
  const InstagramRowWidget({
    super.key,
    required this.url,
    required this.handle,
  });
  final String url; // the url of the instagram account
  final String handle; // the handle of the instagram account @...

  @override
  Widget build(BuildContext context) {
    const double horizontalPadding = 8;

    return Row(children: [
      const Icon(FontAwesomeIcons.instagram, color: Colors.white),
      InkWell(
        child: Text(
          handle,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        onTap: () => launchUrl(Uri.parse(url)),
      ).padding(left: horizontalPadding),
    ]);
  }
}
